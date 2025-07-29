import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/models/period.dart';

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
        await db.execute('''
            CREATE TABLE periods (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                start_date INTEGER NOT NULL,
                end_date INTEGER NOT NULL,
                total_days INTEGER NOT NULL
        )
        ''');
		await db.execute('''
			CREATE TABLE period_logs (
					id INTEGER PRIMARY KEY AUTOINCREMENT,
					date TEXT NOT NULL,
					symptom TEXT,
					flow INTEGER NOT NULL,
                    period_id INTEGER,
					FOREIGN KEY (period_id) REFERENCES periods(id) ON DELETE SET NULL
			)
		''');
	}

    // Periods

    Future<PeriodEntry> createPeriod(PeriodEntry entry) async {
		final db = await instance.database;
		final id = await db.insert('periods', entry.toMap());
		return entry.copyWith(id: id);
	}

	Future<List<PeriodEntry>> readAllPeriods() async {
		final db = await instance.database;
		const orderBy = 'start_date DESC';
		final result = await db.query('periods', orderBy: orderBy);

		return result.map((json) => PeriodEntry.fromMap(json)).toList();
	}

    Future<PeriodEntry?> readLastPeriod() async {
        final db = await instance.database;
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
        final db = await instance.database;
        return db.update(
            'periods',
            period.toMap(),
            where: 'id = ?',
            whereArgs: [period.id],
        );
    }

	Future<int> deletePeriod(int id) async {
		final db = await instance.database;
		return await db.delete(
			'periods',
			where: 'id = ?',
			whereArgs: [id],
		);
	}

    // Period logs

    Future<PeriodLogEntry> createPeriodLog(PeriodLogEntry entry) async {
		final db = await instance.database;
        
        final id = await db.insert('period_logs', entry.toMap());

        await _recalculateAndAssignPeriods(db);

        return await readPeriodLog(id);
	}

	Future<List<PeriodLogEntry>> readAllPeriodLogs() async {
		final db = await instance.database;
		const orderBy = 'date DESC';
		final result = await db.query('period_logs', orderBy: orderBy);

		return result.map((json) => PeriodLogEntry.fromMap(json)).toList();
	}

    Future<PeriodLogEntry> readPeriodLog(id) async {
		final db = await instance.database;

		final result = await db.query(
            'period_logs', 
            where: 'id = $id', 
            );

		return result.map((json) => PeriodLogEntry.fromMap(json)).first;
	}

	Future<int> deletePeriodLog(int id) async {
		final db = await instance.database;
		return await db.delete(
			'period_logs',
			where: 'id = ?',
			whereArgs: [id],
		);
	}

    // Other

    Future close() async {
		final db = await instance.database;
		_database = null;
		db.close();
	}

    // Helper functions

    Future<void> _recalculateAndAssignPeriods(Database db) async {
        await db.delete('periods');

        final List<Map<String, dynamic>> allEntryMaps = await db.query(
            'period_logs',
            orderBy: 'date ASC',
        );
        final List<PeriodLogEntry> allEntries = allEntryMaps.map((json) => PeriodLogEntry.fromMap(json)).toList();

        if (allEntries.isEmpty) {
            return;
        }

        DateTime? currentPeriodStartDate;
        DateTime? currentPeriodEndDate;
        int currentPeriodTotalDays = 0;
        List<int> currentPeriodEntryIds = [];

        for (int i = 0; i < allEntries.length; i++) {
            final entry = allEntries[i];

            if (currentPeriodStartDate == null) {
                currentPeriodStartDate = entry.date;
                currentPeriodEndDate = entry.date;
                currentPeriodEntryIds.add(entry.id!);
            } else {
                if (entry.date.difference(currentPeriodEndDate!).inDays <= 1) {
                    currentPeriodEndDate = entry.date;
                    currentPeriodEntryIds.add(entry.id!);
                } else {
                    currentPeriodTotalDays = currentPeriodEndDate.difference(currentPeriodStartDate).inDays + 1;
                    final newPeriod = PeriodEntry(
                        startDate: currentPeriodStartDate,
                        endDate: currentPeriodEndDate,
                        totalDays: currentPeriodTotalDays,
                    );
                    final createdPeriod = await createPeriod(newPeriod);
                    final assignedPeriodId = createdPeriod.id;

                    await db.transaction((txn) async {
                        for (int entryId in currentPeriodEntryIds) {
                            await txn.update(
                                'period_logs',
                                {'period_id': assignedPeriodId},
                                where: 'id = ?',
                                whereArgs: [entryId],
                            );
                        }
                    });

                    currentPeriodStartDate = entry.date;
                    currentPeriodEndDate = entry.date;
                    currentPeriodEntryIds = [entry.id!];
                }
            }
        }

        if (currentPeriodStartDate != null) {
          if (currentPeriodEndDate != null) {
            currentPeriodTotalDays = currentPeriodEndDate.difference(currentPeriodStartDate).inDays + 1;
          }else{
            currentPeriodTotalDays = 1;
          }
          final newPeriod = PeriodEntry(
            startDate: currentPeriodStartDate,
            endDate: currentPeriodEndDate!,
            totalDays: currentPeriodTotalDays,
          );
          final createdPeriod = await createPeriod(newPeriod);
          final assignedPeriodId = createdPeriod.id;

          await db.transaction((txn) async {
            for (int entryId in currentPeriodEntryIds) {
              await txn.update(
                  'period_logs',
                  {'period_id': assignedPeriodId},
                  where: 'id = ?',
                  whereArgs: [entryId],
              );
            }
          });
        }
    }
}