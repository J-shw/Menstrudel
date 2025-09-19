import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';

class PillsRepository {
  final dbProvider = AppDatabase.instance;

  static const String _whereRegimenId = 'regimen_id = ?';

  Future<PillIntake> createPillIntake(PillIntake intake) async {
    final db = await dbProvider.database;
    final id = await db.insert('PillIntake', intake.toMap());
    return intake.copyWith(id: id);
  }

  /// Delete the last taken pill entry. For if user accidentally logs pill taken.
  Future<void> undoLastPillIntake(int regimenId) async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> lastIntake = await db.query(
      'PillIntake',
      where: _whereRegimenId,
      whereArgs: [regimenId],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (lastIntake.isNotEmpty) {
      final int idToDelete = lastIntake.first['id'] as int;
      await db.delete(
        'PillIntake',
        where: 'id = ?',
        whereArgs: [idToDelete],
      );
    }
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
      where: _whereRegimenId,
      whereArgs: [regimenId],
    );
    return result.map((json) => PillIntake.fromMap(json)).toList();
  }

  Future<PillReminder?> readReminderForRegimen(int regimenId) async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'PillReminder',
      where: _whereRegimenId,
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
    late PillRegimen createdRegimen; 
    
    await db.transaction((txn) async {
      await txn.update('PillRegimen', {'is_active': 0}, where: 'is_active = 1');
      final id = await txn.insert('PillRegimen', regimen.toMap());
      createdRegimen = regimen.copyWith(id: id); 
    });
    return createdRegimen; 
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
      where: _whereRegimenId,
      whereArgs: [reminder.regimenId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final values = reminder.toMap();
      values.remove('id');

      await db.update(
        'PillReminder',
        values,
        where: _whereRegimenId,
        whereArgs: [reminder.regimenId],
      );
    } else {
      await db.insert('PillReminder', reminder.toMap());
    }
  }
}