import 'dart:convert';

import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/flows/flow_data.dart';

class PeriodsRepository {
  final dbProvider = AppDatabase.instance;
  static const String _whereId = 'id = ?';

  final Manager manager;

  PeriodsRepository() : manager = Manager(AppDatabase.instance);

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

  /// Reads all periods since the given date
  Future<List<Period>> readPeriodsSince(DateTime date) async {
    final db = await dbProvider.database;
    final result = await db.query(
      'periods',
      where: 'start_date >= ?',
      whereArgs: [date.millisecondsSinceEpoch],
      orderBy: 'start_date DESC',
    );

    return result.map((json) => Period.fromMap(json)).toList();
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
    return await db.delete('periods', where: _whereId, whereArgs: [id]);
  }

  /// Recalculates periods based on existing period logs and assigns them accordingly.
  Future<Map<int, int>> recalculateAndAssignPeriods(List<LogDay> logs) async {
    final db = await dbProvider.database;
    await db.delete('periods');

    final allEntries = logs.where((log) => log.flow != FlowRate.none).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (allEntries.isEmpty) {
      return {};
    }

    final Map<int, int> allLogUpdates = {};
    List<LogDay> currentPeriodLogs = [];

    for (final entry in allEntries) {
      if (currentPeriodLogs.isEmpty ||
          entry.date.difference(currentPeriodLogs.last.date).inDays > 1) {
        if (currentPeriodLogs.isNotEmpty) {
          final clusterMap = await _createPeriodFromLogs(db, currentPeriodLogs);
          allLogUpdates.addAll(clusterMap);
        }
        currentPeriodLogs = [entry];
      } else {
        currentPeriodLogs.add(entry);
      }
    }

    if (currentPeriodLogs.isNotEmpty) {
      final clusterMap = await _createPeriodFromLogs(db, currentPeriodLogs);
      allLogUpdates.addAll(clusterMap);
    }

    return allLogUpdates;
  }

  /// Creates a Period entry in the DB from logs with at flow rate.
  Future<Map<int, int>> _createPeriodFromLogs(
    Database db,
    List<LogDay> logs,
  ) async {
    final Map<int, int> updates = {};
    final periodDays = logs.where((log) => log.flow != FlowRate.none).toList();

    if (periodDays.isEmpty) return updates;

    final startDate = periodDays.first.date;
    final endDate = periodDays.last.date;

    final periodId = await db.insert('periods', {
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'total_days': endDate.difference(startDate).inDays + 1,
    });

    for (final log in periodDays) {
      updates[log.id!] = periodId;
    }

    return updates;
  }

  /// Fetches monthly flow data exclusively from logs that are part of a period.
  /// Takes a starting date to limit the results to recent data for insights purposes.
  Future<List<MonthlyFlowData>> getMonthlyPeriodFlowsSince(DateTime date) async {
    final db = await dbProvider.database;
    final List<MonthlyFlowData> allMonthlyFlows = [];

    final allPeriods = await readPeriodsSince(date);

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
          MonthlyFlowData(monthLabel: monthKey, flows: flowInts),
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
    //TODO: Needs to be refactored with new log/period split - But for now works.
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('periods') ||
          !importData.containsKey('period_logs') ||
          !importData.containsKey('log_symptoms')) {
        throw const FormatException(
          'Invalid import file: Missing "periods" or "period_logs" or "log_symptoms" data.',
        );
      }

      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException(
          'Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.',
        );
      }

      final Map<int, int> periodIdMap = {};
      final Map<int, int> logIdMap = {};

      await db.transaction((txn) async {
        await txn.delete('period_logs');
        await txn.delete('periods');
        await txn.delete('log_symptoms');

        final List periods = importData['periods'] as List;
        for (final Map<String, dynamic> period
            in periods.cast<Map<String, dynamic>>()) {
          final int oldPeriodId = period['id'] as int;

          final Map<String, dynamic> dataToInsert = Map.from(period)
            ..remove('id');

          final int newPeriodId = await txn.insert(
            'periods',
            dataToInsert,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          periodIdMap[oldPeriodId] = newPeriodId;
        }

        final List periodLogsRaw = importData['period_logs'] as List;
        for (final Map<String, dynamic> logRaw
            in periodLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          final int oldLogId = logRaw['id'] as int;
          final int? oldPeriodIdFk = logRaw['period_id'] as int?;

          logToInsert.remove('id');

          final int? newPeriodIdFk = periodIdMap[oldPeriodIdFk];
          logToInsert['period_id'] = newPeriodIdFk;

          final rawFlow = logToInsert['flow'];
          if (rawFlow is int &&
              rawFlow >= 0 &&
              rawFlow < FlowRate.values.length) {
            logToInsert['flow'] = rawFlow;
          } else {
            logToInsert['flow'] = 0;
          }

          final int newLogId = await txn.insert(
            'period_logs',
            logToInsert,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          logIdMap[oldLogId] = newLogId;
        }

        final List logSymptoms = importData['log_symptoms'] as List;
        for (final Map<String, dynamic> symptom
            in logSymptoms.cast<Map<String, dynamic>>()) {
          final int? oldLogIdFk = symptom['log_id_fk'] as int?;

          final int? newLogIdFk = logIdMap[oldLogIdFk];

          if (newLogIdFk != null) {
            await txn.insert('log_symptoms', {
              'log_id_fk': newLogIdFk,
              'symptom': symptom['symptom'],
            }, conflictAlgorithm: ConflictAlgorithm.replace);
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
      await txn.delete('log_symptoms');
    });
  }
}
