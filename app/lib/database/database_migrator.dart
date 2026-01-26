import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class DatabaseMigrator {
  /// Entry point for migrations
  static Future<void> upgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: Remove old migrations
    
    // v2.3.0
    if (oldVersion < 2) await createPillTables(db);
    // v2.6.0
    if (oldVersion < 3) await _migrateSymptomsStrings(db);
    // v2.7.0
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE period_logs ADD COLUMN painLevel INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 5) await db.execute('UPDATE period_logs SET flow = flow + 1');
    // v2.8.0
    if (oldVersion < 6) {
      await db.execute('UPDATE period_logs SET flow = flow + 1 WHERE flow > 0');
    }
    // v3.1.0
    if (oldVersion < 7) {
      await db.execute('''
        CREATE TABLE log_symptoms (
          log_id_fk INTEGER,
          symptom TEXT NOT NULL,
          PRIMARY KEY (log_id_fk, symptom),
          FOREIGN KEY (log_id_fk) REFERENCES period_logs (id) ON DELETE CASCADE
        )
        ''');
      await _migrateSymptomsToTable(db);
      await db.execute('ALTER TABLE period_logs DROP COLUMN symptoms');
    }
    // v3.2.0
    if (oldVersion < 8) {
      await _migrateToNewPeriodLogsTable(db);
    }
    // v3.3.0
    if (oldVersion < 9) await createLarcTables(db);
    // v3.5.0
    if (oldVersion < 10) await createSanitaryProductTables(db);
    // v4.0.0
    if (oldVersion < 11) {
      await createSexualActivityTables(db);
      await createUserTables(db);
      }
  }

  // --- Table Creation Methods ---

  static Future<void> createPeriodTables(Database db) async {
    await db.execute('''
        CREATE TABLE periods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_date INTEGER NOT NULL,
            end_date INTEGER NOT NULL,
            total_days INTEGER NOT NULL
        )
      ''');
  }

  static Future<void> createLogTables(Database db) async {
    // TODO: Rename table to logs
    await db.execute('''
        CREATE TABLE period_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            flow INTEGER NOT NULL,
            painLevel INTEGER,
            period_id INTEGER,
            FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE SET NULL
        )
        ''');
    await db.execute('''
        CREATE TABLE log_symptoms (
          log_id_fk INTEGER,
          symptom TEXT NOT NULL,
          PRIMARY KEY (log_id_fk, symptom),
          FOREIGN KEY (log_id_fk) REFERENCES period_logs (id) ON DELETE CASCADE
        )
        ''');
  }

  static Future<void> createPillTables(Database db) async {
    await db.execute('''
      CREATE TABLE PillRegimen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        active_pills INTEGER NOT NULL,
        placebo_pills INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        is_active INTEGER NOT NULL
      )
      ''');
    await db.execute('''
      CREATE TABLE PillIntake (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        regimen_id INTEGER NOT NULL,
        taken_at TEXT NOT NULL,
        scheduled_date TEXT NOT NULL,
        status TEXT NOT NULL,
        pill_number_in_cycle INTEGER NOT NULL,
        FOREIGN KEY (regimen_id) REFERENCES PillRegimen (id) ON DELETE CASCADE
      )
      ''');
    await db.execute('''
      CREATE TABLE PillReminder (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        regimen_id INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        is_enabled INTEGER NOT NULL,
        FOREIGN KEY (regimen_id) REFERENCES PillRegimen (id) ON DELETE CASCADE
      )
      ''');
  }

  static Future<void> createLarcTables(Database db) async {
    await db.execute('''
      CREATE TABLE larc_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        note TEXT
      )
      ''');
  }

  static Future<void> createSanitaryProductTables(Database db) async {
    await db.execute('''
      CREATE TABLE sanitary_product_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        logTime TEXT NOT NULL,
        reminderTime TEXT NOT NULL,
        removedTime TEXT,
        type TEXT NOT NULL,
        note TEXT
      )
      ''');
  }

  static Future<void> createSexualActivityTables(Database db) async {
    await db.execute('''
      CREATE TABLE sexual_activity_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date_time TEXT NOT NULL,
        sex_type TEXT,
        participation_type TEXT,
        protection_used INTEGER,
        protection_type TEXT,
        note TEXT
      )
      ''');
  }

  static Future<void> createUserTables(Database db) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        name TEXT NOT NULL,
        birth_date TEXT,
        primary_goal TEXT NOT NULL,
        onboarding_complete INTEGER NOT NULL DEFAULT 0
        )
      ''');
  }

  // --- Migration Logic ---

  static Future<void> _migrateSymptomsStrings(Database db) async {
    const map = {
      'Headache': 'headache',
      'Fatigue': 'fatigue',
      'Cramps': 'cramps',
      'Nausea': 'nausea',
      'Mood Swings': 'moodSwings',
      'Bloating': 'bloating',
      'Acne': 'acne',
    };

    final logs = await db.query('period_logs');
    for (final row in logs) {
      final String? oldJson = row['symptoms'] as String?;
      if (oldJson == null || oldJson.isEmpty) continue;

      final List oldList = jsonDecode(oldJson);
      final newList = oldList.map((s) => map[s]).where((s) => s != null).toList();

      await db.update(
        'period_logs',
        {'symptoms': jsonEncode(newList)},
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    }
  }

  static Future<void> _migrateSymptomsToTable(Database db) async {
    final logs = await db.query('period_logs', columns: ['id', 'symptoms']);
    final batch = db.batch();

    for (final log in logs) {
      if (log['symptoms'] == null) continue;
      try {
        final List symptoms = jsonDecode(log['symptoms'] as String);
        for (final s in symptoms) {
          batch.insert('log_symptoms', {
            'log_id_fk': log['id'],
            'symptom': s.toString(),
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      } catch (e) {
        debugPrint('Migration error: $e');
      }
    }
    await batch.commit(noResult: true);
  }

  static Future<void> _migrateToNewPeriodLogsTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(''' 
        CREATE TABLE period_logs_new ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            date TEXT NOT NULL, 
            flow INTEGER NOT NULL, 
            painLevel INTEGER, 
            period_id INTEGER, 
            FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE SET NULL 
          ) 
      ''');
      await txn.execute('''
        INSERT INTO period_logs_new (id, date, flow, painLevel, period_id)
        SELECT id, date, flow, painLevel, period_id FROM period_logs
      ''');
      await txn.execute('DROP TABLE period_logs');
      await txn.execute('ALTER TABLE period_logs_new RENAME TO period_logs');
    });
  }
}