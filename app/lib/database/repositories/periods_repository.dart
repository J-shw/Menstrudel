import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/period_logs/symptom_enum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/flows/flow_data.dart';
import 'package:menstrudel/utils/exceptions.dart';

class PeriodsRepository {
  final dbProvider = AppDatabase.instance;
  static const String _whereId = 'id = ?';

  final Manager manager;

  PeriodsRepository() : manager = Manager(AppDatabase.instance); 

  Future<void> logPeriodFromWatch() async {
    debugPrint('Received request from watch! Logging period now...');

    try {
      final newLog = PeriodDay(
        date: DateTime.now(),
        flow: FlowRate.medium,
        painLevel: 0,
      );

      await createPeriodLog(newLog);
      debugPrint('Successfully logged period from the watch.');

    } on DuplicateLogException {
      debugPrint('Watch log ignored: A log for today already exists.');
    } catch (e) {
      debugPrint('An error occurred while logging from the watch: $e');
    }
  }

  /// Validates a log's date, throwing exceptions for future or duplicate dates.
  Future<void> _validateLogDate(Database db, DateTime date, {int? idToExclude}) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final entryDate = DateUtils.dateOnly(date);

    if (entryDate.isAfter(today)) {
      throw FutureDateException('Logs cannot be for future dates.');
    }

    String whereClause = 'date(date) = date(?)';
    if (idToExclude != null) {
      whereClause += ' AND id != ?';
    }

    final existingLogs = await db.query(
      'period_logs',
      where: whereClause,
      whereArgs: idToExclude != null ? [date.toIso8601String(), idToExclude] : [date.toIso8601String()],
      limit: 1,
    );

    if (existingLogs.isNotEmpty) {
      throw DuplicateLogException('A log already exists for this date.');
    }
  }

  // Periods

  Future<Period> createPeriod(Period entry) async {
    final db = await dbProvider.database;
    final id = await db.insert('periods', entry.toMap());
    return entry.copyWith(id: id);
  }

  Future<List<Period>> readAllPeriods() async {
    final db = await dbProvider.database;
    const orderBy = 'start_date DESC';
    final result = await db.query('periods', orderBy: orderBy);

    return result.map((json) => Period.fromMap(json)).toList();
  }

  Future<Period?> readLastPeriod() async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'periods',
      orderBy: 'start_date DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Period.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updatePeriod(Period period) async {
    final db = await dbProvider.database;
    return db.update(
      'periods',
      period.toMap(),
      where: _whereId,
      whereArgs: [period.id],
    );
  }

  Future<int> deletePeriod(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'periods',
      where: _whereId,
      whereArgs: [id],
    );
  }

  // Period logs

  Future<PeriodDay> createPeriodLog(PeriodDay entry) async {
    final db = await dbProvider.database;

    await _validateLogDate(db, entry.date);

    int newLogId = -1;
    await db.transaction((txn) async {
      newLogId = await txn.insert('period_logs', entry.toMap());

      if (entry.symptoms.isNotEmpty) {
        final batch = txn.batch();
        for (final symptom in entry.symptoms!) {
          batch.insert('log_symptoms', {
            'log_id_fk': newLogId,
            'symptom': symptom,
          });
        }
        await batch.commit(noResult: true);
      }
    });

    await _recalculateAndAssignPeriods(db);
    return await readPeriodLog(newLogId);
  }

  Future<List<PeriodDay>> readAllPeriodLogs() async {
    final db = await dbProvider.database;

    const orderBy = 'date DESC';
    final logsResult = await db.query('period_logs', orderBy: orderBy);

    final symptomsResult = await db.query('log_symptoms');

    final Map<int, List<String>> symptomMap = {};
    for (final row in symptomsResult) {
      final int logId = row['log_id_fk'] as int;
      final String symptom = row['symptom'] as String;
      (symptomMap[logId] ??= []).add(symptom);
    }

    return logsResult.map((json) {
      final int logId = json['id'] as int;
      final List<String> symptoms = symptomMap[logId] ?? [];
      return PeriodDay.fromMap(json, symptoms: symptoms);
    }).toList();
  }

  Future<PeriodDay> readPeriodLog(int id) async {
    final db = await dbProvider.database;

    final result = await db.query(
      'period_logs',
      where: _whereId,
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Log with id $id not found');
    }

    final symptomsResult = await db.query(
      'log_symptoms',
      columns: ['symptom'],
      where: 'log_id_fk = ?',
      whereArgs: [id],
    );

    final List<String> symptoms = symptomsResult
        .map((row) => row['symptom'] as String)
        .toList();

    return PeriodDay.fromMap(result.first, symptoms: symptoms);
  }

  Future<int> updatePeriodLog(PeriodDay entry) async {
    final db = await dbProvider.database;

    if (entry.id == null) {
      debugPrint('Error: updatePeriodLog called with null ID');
      return 0;
    }

    await _validateLogDate(db, entry.date, idToExclude: entry.id);

    int result = 0;

    await db.transaction((txn) async {
      result = await txn.update(
        'period_logs',
        entry.toMap(),
        where: _whereId,
        whereArgs: [entry.id],
      );

      if (result > 0) {
        await txn.delete(
          'log_symptoms',
          where: 'log_id_fk = ?',
          whereArgs: [entry.id],
        );

        if (entry.symptoms.isNotEmpty) {
          final batch = txn.batch();
          for (final symptom in entry.symptoms) {
            batch.insert('log_symptoms', {
              'log_id_fk': entry.id,
              'symptom': symptom,
            });
          }
          await batch.commit(noResult: true);
        }
      }
    });

    if (result > 0) {
      await _recalculateAndAssignPeriods(db);
    }

    return result;
  }

  Future<int> deletePeriodLog(int id) async {
    final db = await dbProvider.database;
    final int result = await db.delete(
      'period_logs',
      where: _whereId,
      whereArgs: [id],
    );

    if (result > 0) {
      await _recalculateAndAssignPeriods(db);
    }

    return result;
  }

  // Other

  Future<void> _recalculateAndAssignPeriods(Database db) async {
    await db.delete('periods');

    final allEntryMaps = await db.query(
      'period_logs',
      orderBy: 'date ASC',
      where: 'flow != ?',
      whereArgs: [FlowRate.none.index],
    );
    final allEntries = allEntryMaps.map((e) => PeriodDay.fromMap(e)).toList();

    if (allEntries.isEmpty) {
      return; 
    }

    List<PeriodDay> currentPeriodLogs = [];

    for (final entry in allEntries) {
      if (currentPeriodLogs.isEmpty || entry.date.difference(currentPeriodLogs.last.date).inDays > 1) {
        if (currentPeriodLogs.isNotEmpty) {
          await _createPeriodFromLogs(db, currentPeriodLogs);
        }
        currentPeriodLogs = [entry];
      } else {
        currentPeriodLogs.add(entry);
      }
    }
    if (currentPeriodLogs.isNotEmpty) {
      await _createPeriodFromLogs(db, currentPeriodLogs);
    }
  }

  /// Creates a Period entry in the DB from logs with at flow rate.
  Future<void> _createPeriodFromLogs(Database db, List<PeriodDay> logs) async {
    final periodDays = logs.where((log) => log.flow != FlowRate.none).toList();

    if (periodDays.isEmpty) {
      return;
    }

    final startDate = periodDays.first.date;
    final endDate = periodDays.last.date;
    final totalDays = endDate.difference(startDate).inDays + 1;

    final newPeriodMap = {
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'total_days': totalDays,
    };

    final periodId = await db.insert('periods', newPeriodMap);

    final logIds = periodDays.map((log) => log.id!).toList();

    await db.transaction((txn) async {
      for (final logId in logIds) {
        await txn.update(
          'period_logs',
          {'period_id': periodId},
          where: _whereId,
          whereArgs: [logId],
        );
      }
    });
  }

  /// Fetches monthly flow data exclusively from logs that are part of a period.
  Future<List<MonthlyFlowData>> getMonthlyPeriodFlows() async {
    final db = await dbProvider.database;
    final List<MonthlyFlowData> allMonthlyFlows = [];

    final allPeriods = await readAllPeriods();

    for (final period in allPeriods) {
      if (period.id == null) continue;

      final logsResult = await db.query(
        'period_logs',
        where: 'period_id = ?',
        whereArgs: [period.id],
        orderBy: 'date ASC',
      );

      final flowInts = logsResult.map((log) => log['flow'] as int).toList();

      if (flowInts.isNotEmpty) {
        final monthKey = DateFormat('MMM').format(period.startDate);
        
        allMonthlyFlows.add(
          MonthlyFlowData(
            monthLabel: monthKey,
            flows: flowInts,
          ),
        );
      }
    }
    
    return allMonthlyFlows;
  }
}

class Manager {
  final AppDatabase dbProvider;

  Manager(this.dbProvider);

  /// Returns periods,log_symptoms and period_logs data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final periodLogs = await db.query('period_logs');
    final periods = await db.query('periods');
    final logSymptoms = await db.query('log_symptoms');


    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();


    final exportData = {
      'periods': periods,
      'period_logs': periodLogs,
      'log_symptoms': logSymptoms,
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'db_version': dbVersion,
    };

    final jsonString = jsonEncode(exportData);
    
    return jsonString;
  }

  /// Imports periods, log_symptoms and period_logs data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('periods') || !importData.containsKey('period_logs') || !importData.containsKey('log_symptoms')) {
        throw const FormatException('Invalid import file: Missing "periods" or "period_logs" or "log_symptoms" data.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      final Map<int, int> periodIdMap = {};
      final Map<int, int> logIdMap = {};

      await db.transaction((txn) async {
        await txn.delete('period_logs');
        await txn.delete('periods');
        await txn.delete('log_symptoms');
        
        final List periods = importData['periods'] as List;
        for (final Map<String, dynamic> period in periods.cast<Map<String, dynamic>>()) {
          final int oldPeriodId = period['id'] as int;
          
          final Map<String, dynamic> dataToInsert = Map.from(period)..remove('id');
          
          final int newPeriodId = await txn.insert('periods', dataToInsert, conflictAlgorithm: ConflictAlgorithm.replace);
          
          periodIdMap[oldPeriodId] = newPeriodId;
        }

        final List periodLogsRaw = importData['period_logs'] as List;
        for (final Map<String, dynamic> logRaw in periodLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          final int oldLogId = logRaw['id'] as int;
          final int? oldPeriodIdFk = logRaw['period_id'] as int?;

          logToInsert.remove('id');

          final int? newPeriodIdFk = periodIdMap[oldPeriodIdFk];
          logToInsert['period_id'] = newPeriodIdFk;

          final rawFlow = logToInsert['flow'];
          if (rawFlow is int && rawFlow >= 0 && rawFlow < FlowRate.values.length) {
              logToInsert['flow'] = rawFlow;
          } else {
              logToInsert['flow'] = 0; 
          }
          
          final int newLogId = await txn.insert('period_logs', logToInsert, conflictAlgorithm: ConflictAlgorithm.replace);
          
          logIdMap[oldLogId] = newLogId;
        }

        final List logSymptoms = importData['log_symptoms'] as List;
        for (final Map<String, dynamic> symptom in logSymptoms.cast<Map<String, dynamic>>()) {

          final int? oldLogIdFk = symptom['log_id_fk'] as int?;

          final int? newLogIdFk = logIdMap[oldLogIdFk];

          if (newLogIdFk != null) {
            await txn.insert('log_symptoms', 
              {
                'log_id_fk': newLogIdFk,
                'symptom': symptom['symptom'],
              },
              conflictAlgorithm: ConflictAlgorithm.replace
            );
          }
        }
      });

    } on FormatException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  /// Deletes all entries from the period_logs and periods tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('period_logs');
      await txn.delete('periods');
    });
  }
}