import 'package:flutter/material.dart';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/database/validation/log_validator.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/utils/exceptions.dart';

class LogsRepository {
  final dbProvider = AppDatabase.instance;
  static const String _whereId = 'id = ?';

  // Helpers

  Future<void> logFromWatch() async {
    debugPrint('Received request from watch! Logging entry now...');

    try {
      final newLog = LogDay(
        date: DateTime.now(),
        flow: FlowRate.medium,
        painLevel: null,
      );

      await upsertLog(newLog);
      debugPrint('Successfully logged period from the watch.');
    } on DuplicateLogException {
      debugPrint('Watch log ignored: A log for today already exists.');
    } catch (e) {
      debugPrint('An error occurred while logging from the watch: $e');
    }
  }

  // Main methods

  /// Updates and inserts a log entry.
  /// If the entry has an ID, it updates the existing log; otherwise, it creates a new one.
  /// Validates for duplicate/future dates before performing the operation.
  /// Throws [DuplicateLogException] if a log already exists for the given date - Use [idToExclude] to exclude an ID when updating.
  /// Throws [FutureDateException] if the date is in the future.
  /// Returns the ID of the inserted or updated log.
  Future<int> upsertLog(LogDay entry) async {
    final validator = LogValidator(this);
    await validator.validate(entry.date, idToExclude: entry.id);

    final db = await dbProvider.database;

    return await db.transaction((txn) async {
      int logId;

      if (entry.id != null) {
        logId = entry.id!;
        await txn.update(
          'period_logs',
          entry.toMap(),
          where: 'id = ?',
          whereArgs: [logId],
        );
      } else {
        logId = await txn.insert('period_logs', entry.toMap());
      }

      await txn.delete(
        'log_symptoms',
        where: 'log_id_fk = ?',
        whereArgs: [logId],
      );

      if (entry.symptoms.isNotEmpty) {
        final batch = txn.batch();
        for (final symptom in entry.symptoms) {
          batch.insert('log_symptoms', {
            'log_id_fk': logId,
            'symptom': symptom.getDbName(),
          });
        }
        await batch.commit(noResult: true);
      }

      return logId;
    });
  }

  Future<List<LogDay>> readAllLogs() async {
    final db = await dbProvider.database;

    const orderBy = 'date DESC';
    final logsResult = await db.query('period_logs', orderBy: orderBy);

    final symptomsResult = await db.query('log_symptoms');

    final Map<int, List<Symptom>> symptomMap = {};
    for (final row in symptomsResult) {
      final int logId = row['log_id_fk'] as int;
      final String symptom = row['symptom'] as String;
      (symptomMap[logId] ??= []).add(Symptom.fromDbString(symptom));
    }

    return logsResult.map((json) {
      final int logId = json['id'] as int;
      final List<Symptom> symptoms = symptomMap[logId] ?? [];
      return LogDay.fromMap(json, symptoms: symptoms);
    }).toList();
  }

  Future<LogDay> readLog(int id) async {
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

    final List<Symptom> symptoms = symptomsResult
        .map((row) => Symptom.fromDbString(row['symptom'] as String))
        .toList();

    return LogDay.fromMap(result.first, symptoms: symptoms);
  }

  /// Reads all logs since the given date, including their associated symptoms.
  Future<List<LogDay>> readLogsSince(DateTime date) async {
    final db = await dbProvider.database;

    final logsResult = await db.query(
      'period_logs',
      where: 'date >= ?',
      whereArgs: [date.millisecondsSinceEpoch],
      orderBy: 'date DESC',
    );

    final symptomsResult = await db.query('log_symptoms');

    final Map<int, List<Symptom>> symptomMap = {};
    for (final row in symptomsResult) {
      final int logId = row['log_id_fk'] as int;
      final String symptom = row['symptom'] as String;
      (symptomMap[logId] ??= []).add(Symptom.fromDbString(symptom));
    }

    return logsResult.map((json) {
      final int logId = json['id'] as int;
      final List<Symptom> symptoms = symptomMap[logId] ?? [];
      return LogDay.fromMap(json, symptoms: symptoms);
    }).toList();
  }

  Future<void> updateLogPeriodIds(Map<int, int> mapping) async {
    final db = await dbProvider.database;
    final batch = db.batch();

    batch.update('period_logs', {'period_id': -1});

    mapping.forEach((logId, periodId) {
      batch.update(
        'period_logs',
        {'period_id': periodId},
        where: 'id = ?',
        whereArgs: [logId],
      );
    });

    await batch.commit(noResult: true);
  }

  Future<int> deleteLog(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'period_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> existsOnDate(DateTime date, {int? excludeId}) async {
    final db = await dbProvider.database;
    
    String where = 'date(date) = date(?)';
    List<Object?> args = [date.toIso8601String()];

    if (excludeId != null) {
      where += ' AND id != ?';
      args.add(excludeId);
    }

    final result = await db.query(
      'period_logs',
      where: where,
      whereArgs: args,
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Calculates the usage count for every symptom in the database.
  /// This is used for insights and to show the most common symptoms in the UI.
  /// Is filtered by date to only include recent logs for more relevant insights.
  Future<Map<Symptom, int>> getSymptomFrequencySince(DateTime date) async {
    final db = await dbProvider.database;

    final result = await db.rawQuery(
      'SELECT symptom, COUNT(symptom) as count FROM log_symptoms WHERE log_id_fk IN (SELECT id FROM period_logs WHERE date >= ?) GROUP BY symptom',
      [date.toIso8601String()],
    );

    if (result.isEmpty) {
      return {};
    }
    return {
      for (var row in result)
        Symptom.fromDbString(row['symptom'] as String): row['count'] as int,
    };
  }

  Future<int> getSingleSymptomFrequency(Symptom symptom) async {
    final db = await dbProvider.database;

    var key = symptom.getDbName();

    final result = await db.rawQuery(
      'SELECT symptom, COUNT(symptom) as count FROM log_symptoms WHERE symptom LIKE \'$key\' GROUP BY symptom',
    );

    return result.length == 1 ? result[0]["count"] as int : 0;
  }
}
