import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/models/flows/flow_data.dart';

class LogsRepository {
  final dbProvider = AppDatabase.instance;
  static const String _whereId = 'id = ?';

  // Helpers

  Future<void> logFromWatch() async {
    debugPrint('Received request from watch! Logging period now...');

    try {
      final newLog = LogDay(
        date: DateTime.now(),
        flow: FlowRate.medium,
        painLevel: null,
      );

      await createLog(newLog);
      debugPrint('Successfully logged period from the watch.');
    } on DuplicateLogException {
      debugPrint('Watch log ignored: A log for today already exists.');
    } catch (e) {
      debugPrint('An error occurred while logging from the watch: $e');
    }
  }

  // Main methods

  Future<LogDay> createLog(LogDay entry) async {
    final db = await dbProvider.database;

    await _validateLogDate(db, entry.date);

    int newLogId = -1;
    await db.transaction((txn) async {
      newLogId = await txn.insert('period_logs', entry.toMap());

      if (entry.symptoms.isNotEmpty) {
        final batch = txn.batch();
        for (final symptom in entry.symptoms) {
          batch.insert('log_symptoms', {
            'log_id_fk': newLogId,
            'symptom': symptom.getDbName(),
          });
        }
        await batch.commit(noResult: true);
      }
    });

    await _recalculateAndAssignPeriods(db);
    return await readLog(newLogId);
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
}