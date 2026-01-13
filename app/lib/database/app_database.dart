import 'package:menstrudel/database/database_migrator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      version: 11,
      onCreate: _createDB,
      onUpgrade: DatabaseMigrator.upgrade,
    );
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await DatabaseMigrator.createPeriodTables(db);

    await DatabaseMigrator.createLogTables(db);

    await DatabaseMigrator.createPillTables(db);

    await DatabaseMigrator.createLarcTables(db);

    await DatabaseMigrator.createSanitaryProductTables(db);

    await DatabaseMigrator.createSexualActivityTables(db);

    await DatabaseMigrator.createUserTables(db);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}