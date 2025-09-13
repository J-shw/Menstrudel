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
        version: 4,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
      return _database!;
    }

  Future _createDB(Database db, int version) async {
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
          symptoms  TEXT,
          flow INTEGER NOT NULL,
          painLevel INTEGER NOT NULL,
          period_id INTEGER,
          FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE SET NULL
      )
      '''
    );
    
    await _createPillTables(db);
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

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}