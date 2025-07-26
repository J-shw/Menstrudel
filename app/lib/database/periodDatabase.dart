import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:menstrudel/models/period_logs.dart';

class PeriodDatabase {
static final PeriodDatabase instance = PeriodDatabase._init();
static Database? _database;

PeriodDatabase._init();

Future<Database> get database async {
	if (_database != null) return _database!;
		_database = await _initDB('periods.db');
		return _database!;
	}

	Future<Database> _initDB(String filePath) async {
		final dbPath = await getDatabasesPath();
		final path = join(dbPath, filePath);

		return await openDatabase(
		path,
		version: 1,
		onCreate: _createDB,
		);
	}

	Future _createDB(Database db, int version) async {
		const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
		const textType = 'TEXT NOT NULL';
		const nullableTextType = 'TEXT';

		await db.execute('''
		CREATE TABLE period_logs (
			id $idType,
			date $textType,
			symptom $nullableTextType,
			flow $textType
		)
		''');
	}

	Future<PeriodEntry> create(PeriodEntry entry) async {
		final db = await instance.database;
		final id = await db.insert('period_logs', entry.toMap());
		return entry.copyWith(id: id);
	}

	Future<PeriodEntry> readSymptom(int id) async {
		final db = await instance.database;
		final maps = await db.query(
			'period_logs',
			columns: ['id', 'date', 'symptom', 'flow'],
			where: 'id = ?',
			whereArgs: [id],
		);

		if (maps.isNotEmpty) {
			return PeriodEntry.fromMap(maps.first);
		} else {
			throw Exception('ID $id not found');
		}
	}

	Future<List<PeriodEntry>> readAllPeriods() async {
		final db = await instance.database;
		const orderBy = 'date DESC';
		final result = await db.query('period_logs', orderBy: orderBy);

		return result.map((json) => PeriodEntry.fromMap(json)).toList();
	}

	Future<int> update(PeriodEntry entry) async {
		final db = await instance.database;
		return db.update(
		'period_logs',
		entry.toMap(),
		where: 'id = ?',
		whereArgs: [entry.id],
		);
	}

	Future<int> delete(int id) async {
		final db = await instance.database;
		return await db.delete(
		'period_logs',
		where: 'id = ?',
		whereArgs: [id],
		);
	}

	Future close() async {
		final db = await instance.database;
		_database = null;
		db.close();
	}
}