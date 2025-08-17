import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';

class PillsRepository {
  final dbProvider = AppDatabase.instance;

  Future<PillIntake> createPillIntake(PillIntake intake) async {
    final db = await dbProvider.database;
    final id = await db.insert('PillIntake', intake.toMap());
    return intake.copyWith(id: id);
  }

  Future<PillRegimen?> readActivePillRegimen() async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'PillRegimen',
      where: 'is_active = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PillRegimen.fromMap(maps.first);
    }
    return null;
  }

  Future<List<PillIntake>> readIntakesForRegimen(int regimenId) async {
    final db = await dbProvider.database;
    final result = await db.query(
      'PillIntake',
      where: 'regimen_id = ?',
      whereArgs: [regimenId],
    );
    return result.map((json) => PillIntake.fromMap(json)).toList();
  }

  Future<PillReminder?> readReminderForRegimen(int regimenId) async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'PillReminder',
      where: 'regimen_id = ?',
      whereArgs: [regimenId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PillReminder.fromMap(maps.first);
    }
    return null;
  }

  Future<PillRegimen> createPillRegimen(PillRegimen regimen) async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.update('PillRegimen', {'is_active': 0}, where: 'is_active = 1');
      final id = await txn.insert('PillRegimen', regimen.toMap());
      return regimen.copyWith(id: id);
    });
    return regimen;
  }

  Future<void> deletePillRegimen(int id) async {
    final db = await dbProvider.database;
    await db.delete(
      'PillRegimen',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> savePillReminder(PillReminder reminder) async {
    final db = await dbProvider.database;
    final existing = await db.query(
      'PillReminder',
      where: 'regimen_id = ?',
      whereArgs: [reminder.regimenId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      await db.update(
        'PillReminder',
        reminder.toMap(),
        where: 'regimen_id = ?',
        whereArgs: [reminder.regimenId],
      );
    } else {
      await db.insert('PillReminder', reminder.toMap());
    }
  }
}