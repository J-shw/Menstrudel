import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class AppDatabase {
    static final AppDatabase instance = AppDatabase._init();
    static Database? _database;

    AppDatabase._init();

    Future<Database> get database async {
      return _database ??= await init();
    }

    Future<Database> init({bool inMemory = false}) async {
      if (_database != null && !inMemory) {
        return _database!;
      }

      String path;
      if (inMemory) {
        path = inMemoryDatabasePath;
      } else {
        final dbPath = await getDatabasesPath();
        path = join(dbPath, 'app_database.db');
      }

      _database = await openDatabase(
        path,
        version: 9,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
      return _database!;
    }

  Future _createDB(Database db, int version) async {

    await _createPeriodTables(db);  
  
    await _createPillTables(db);

    await _createLarcTables(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createPillTables(db);
    }
    if (oldVersion < 3) {
      await _migrateSymptoms(db);
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE period_logs ADD COLUMN painLevel INTEGER NOT NULL DEFAULT 0');
    }
    if (oldVersion < 5) {
      await db.execute('UPDATE period_logs SET flow = flow + 1');
    }
    if (oldVersion < 6) {
      await db.execute('UPDATE period_logs SET flow = flow + 1 WHERE flow > 0');
    }
    if (oldVersion < 7) {
      await db.execute(
        '''
        CREATE TABLE log_symptoms (
          log_id_fk INTEGER,
          symptom TEXT NOT NULL,
          PRIMARY KEY (log_id_fk, symptom),
          FOREIGN KEY (log_id_fk) REFERENCES period_logs (id) ON DELETE CASCADE
        )
        '''
      );
      await migrateSymptomsToNewSymptomTable(db);
      
      await db.execute('ALTER TABLE period_logs DROP COLUMN symptoms');
    }
    if (oldVersion < 8) { 
      await db.transaction((txn) async {

        await txn.execute( 
        ''' 
        CREATE TABLE period_logs_new ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            date TEXT NOT NULL, 
            flow INTEGER NOT NULL, 
            painLevel INTEGER, 
            period_id INTEGER, 
            FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE SET NULL 
          ) 
         ''' 
        );

        await txn.execute(
          '''
          INSERT INTO period_logs_new (id, date, flow, painLevel, period_id)
          SELECT id, date, flow, painLevel, period_id
          FROM period_logs
          '''
        );

        await txn.execute('DROP TABLE period_logs');

        await txn.execute('ALTER TABLE period_logs_new RENAME TO period_logs');
      });
    }
    if (oldVersion < 9) {
      _createLarcTables(db);
    }

  }

    Future<void> _createPeriodTables(Database db) async {
      await db.execute(
      '''
        CREATE TABLE periods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            start_date INTEGER NOT NULL,
            end_date INTEGER NOT NULL,
            total_days INTEGER NOT NULL
        )
      '''
      );
      await db.execute(
        '''
        CREATE TABLE period_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            flow INTEGER NOT NULL,
            painLevel INTEGER,
            period_id INTEGER,
            FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE SET NULL
        )
        '''
      );
      await db.execute(
        '''
        CREATE TABLE log_symptoms (
          log_id_fk INTEGER,
          symptom TEXT NOT NULL,
          PRIMARY KEY (log_id_fk, symptom),
          FOREIGN KEY (log_id_fk) REFERENCES period_logs (id) ON DELETE CASCADE
        )
        '''
      );
    }

  Future<void> _createPillTables(Database db) async {
    await db.execute(
      '''
      CREATE TABLE PillRegimen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        active_pills INTEGER NOT NULL,
        placebo_pills INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        is_active INTEGER NOT NULL
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE PillIntake (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        regimen_id INTEGER NOT NULL,
        taken_at TEXT NOT NULL,
        scheduled_date TEXT NOT NULL,
        status TEXT NOT NULL,
        pill_number_in_cycle INTEGER NOT NULL,
        FOREIGN KEY (regimen_id) REFERENCES PillRegimen (id) ON DELETE CASCADE
      )
      '''
    );
    await db.execute(
      '''
      CREATE TABLE PillReminder (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        regimen_id INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        is_enabled INTEGER NOT NULL,
        FOREIGN KEY (regimen_id) REFERENCES PillRegimen (id) ON DELETE CASCADE
      )
      '''
    );
  }

  Future<void> _createLarcTables(Database db) async {
    await db.execute(
      '''
      CREATE TABLE larc_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
      )
      '''
    );
  }
  Future<void> _migrateSymptoms(Database db) async {
    const symptomMigrationMap = {
      'Headache': 'headache',
      'Fatigue': 'fatigue',
      'Cramps': 'cramps',
      'Nausea': 'nausea',
      'Mood Swings': 'moodSwings',
      'Bloating': 'bloating',
      'Acne': 'acne',
    };

    final allLogs = await db.query('period_logs');

    for (final row in allLogs) {
      final int id = row['id'] as int;
      final String? oldSymptomsJson = row['symptoms'] as String?;

      if (oldSymptomsJson == null || oldSymptomsJson.isEmpty) {
        continue;
      }

      final List<dynamic> oldSymptomList = jsonDecode(oldSymptomsJson);

      final newSymptomList = oldSymptomList
          .map((oldSymptom) => symptomMigrationMap[oldSymptom])
          .where((newSymptom) => newSymptom != null)
          .toList();

      final String newSymptomsJson = jsonEncode(newSymptomList);

      await db.update(
        'period_logs',
        {'symptoms': newSymptomsJson},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> migrateSymptomsToNewSymptomTable(Database db) async {
    final logsToMigrate = await db.query(
      'period_logs',
      columns: ['id', 'symptoms'],
      where: 'symptoms IS NOT NULL AND symptoms != ?',
      whereArgs: ['[]'],
    );

    if (logsToMigrate.isEmpty) {
      return;
    }

    final batch = db.batch();

    for (final log in logsToMigrate) {
      final int logId = log['id'] as int;
      final String rawSymptoms = log['symptoms'] as String;

      List<String> symptoms = [];
      try {
        final List<dynamic> decodedList = jsonDecode(rawSymptoms);

        symptoms = decodedList.cast<String>();
        
      } catch (e) {
        debugPrint('Failed to jsonDecode symptoms "$rawSymptoms" for log $logId: $e');
        continue; 
      }

      for (final symptom in symptoms) {
        batch.insert(
          'log_symptoms',
          {
            'log_id_fk': logId,
            'symptom': symptom,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }

    await batch.commit(noResult: true);
  }
  
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}