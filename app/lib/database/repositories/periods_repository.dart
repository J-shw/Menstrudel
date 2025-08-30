import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/flows/flow_data.dart';
import 'package:menstrudel/utils/exceptions.dart';

class PeriodsRepository {
  final dbProvider = AppDatabase.instance;

  Future<void> deleteAllEntries() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('period_logs');
      await txn.delete('periods');
    });
  }

  // Periods

  Future<PeriodEntry> createPeriod(PeriodEntry entry) async {
    final db = await dbProvider.database;
    final id = await db.insert('periods', entry.toMap());
    return entry.copyWith(id: id);
  }

  Future<List<PeriodEntry>> readAllPeriods() async {
    final db = await dbProvider.database;
    const orderBy = 'start_date DESC';
    final result = await db.query('periods', orderBy: orderBy);

    return result.map((json) => PeriodEntry.fromMap(json)).toList();
  }

  Future<PeriodEntry?> readLastPeriod() async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'periods',
      orderBy: 'start_date DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PeriodEntry.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updatePeriod(PeriodEntry period) async {
    final db = await dbProvider.database;
    return db.update(
      'periods',
      period.toMap(),
      where: 'id = ?',
      whereArgs: [period.id],
    );
  }

  Future<int> deletePeriod(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'periods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Period logs

  Future<PeriodLogEntry> createPeriodLog(PeriodLogEntry entry) async {
    final db = await dbProvider.database;

    final existingLogs = await db.query(
      'period_logs',
      where: 'date(date) = date(?)',
      whereArgs: [entry.date.toIso8601String()],
      limit: 1, 
    );

    if (existingLogs.isNotEmpty) {
      throw DuplicateLogException('A log already exists for this date.');
    }
      
    final id = await db.insert('period_logs', entry.toMap());

    await _recalculateAndAssignPeriods(db);

    return await readPeriodLog(id);
  }

  Future<List<PeriodLogEntry>> readAllPeriodLogs() async {
    final db = await dbProvider.database;
    const orderBy = 'date DESC';
    final result = await db.query('period_logs', orderBy: orderBy);

    return result.map((json) => PeriodLogEntry.fromMap(json)).toList();
  }

  Future<PeriodLogEntry> readPeriodLog(id) async {
    final db = await dbProvider.database;

    final result = await db.query(
      'period_logs', 
      where: 'id = $id', 
    );

    return result.map((json) => PeriodLogEntry.fromMap(json)).first;
  }

  Future<int> deletePeriodLog(int id) async {
    final db = await dbProvider.database;
    final int result = await db.delete(
      'period_logs',
      where: 'id = ?',
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

    final allEntryMaps = await db.query('period_logs', orderBy: 'date ASC');
    final allEntries = allEntryMaps.map((e) => PeriodLogEntry.fromMap(e)).toList();

    if (allEntries.isEmpty) {
      return; 
    }

    List<PeriodLogEntry> currentPeriodLogs = [];

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

  Future<void> _createPeriodFromLogs(Database db, List<PeriodLogEntry> logs) async {
    final startDate = logs.first.date;
    final endDate = logs.last.date;
    final totalDays = endDate.difference(startDate).inDays + 1;

    final newPeriodMap = {
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'total_days': totalDays,
    };

    final periodId = await db.insert('periods', newPeriodMap);

    final logIds = logs.map((log) => log.id!).toList();

    await db.transaction((txn) async {
      for (final logId in logIds) {
        await txn.update(
          'period_logs',
          {'period_id': periodId},
          where: 'id = ?',
          whereArgs: [logId],
        );
      }
    });
  }

  Future<List<MonthlyFlowData>> getMonthlyFlows() async {
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