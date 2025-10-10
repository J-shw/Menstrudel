import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:flutter/material.dart';

class PillsRepository {
  final dbProvider = AppDatabase.instance;
  static const String _whereRegimenId = 'regimen_id = ?';

  late final Manager manager;

  PillsRepository() {
    manager = Manager(AppDatabase.instance, this);
  }

  /// Deletes a specific pill entry by its ID.
  Future<void> deletePillIntake(int intakeId) async {
    final db = await dbProvider.database;
    await db.delete(
      'PillIntake',
      where: 'id = ?',
      whereArgs: [intakeId],
    );
  }

  /// Deletes a pill entry from provide regimenID using pillNumberInCycle
  Future<void> deletePillIntakeByDay(int regimenId, int pillNumberInCycle) async {
    final db = await dbProvider.database;
    
    final List<Map<String, dynamic>> intake = await db.query(
      'PillIntake',
      where: 'regimen_id = ? AND pill_number_in_cycle = ?',
      whereArgs: [regimenId, pillNumberInCycle],
      limit: 1,
    );

    if (intake.isNotEmpty) {
      final int idToDelete = intake.first['id'] as int;
      await db.delete(
        'PillIntake',
        where: 'id = ?',
        whereArgs: [idToDelete],
      );
    }
  }

  /// Creates a new pill intake record or updates an existing one for the same regimen/pill number.
  Future<PillIntake> createOrUpdatePillIntake(PillIntake intake) async {
    final db = await dbProvider.database;
    
    final existingIntakes = await db.query(
      'PillIntake',
      where: 'regimen_id = ? AND pill_number_in_cycle = ?',
      whereArgs: [intake.regimenId, intake.pillNumberInCycle],
      limit: 1,
    );

    if (existingIntakes.isNotEmpty) {
      final existingId = existingIntakes.first['id'] as int;
      
      final Map<String, dynamic> dataToUpdate = intake.toMap();
      dataToUpdate.remove('id');
      
      await db.update(
        'PillIntake',
        dataToUpdate,
        where: 'id = ?',
        whereArgs: [existingId],
      );
      return intake.copyWith(id: existingId);
    } else {
      final id = await db.insert('PillIntake', intake.toMap());
      return intake.copyWith(id: id);
    }
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

class Manager {
  final AppDatabase dbProvider;
  final PillsRepository pillsRepo;

  Manager(this.dbProvider, this.pillsRepo);

  /// Returns pill data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final pillRegimen = await db.query('PillRegimen');
    final pillIntakes = await db.query('PillIntake');
    final pillReminders = await db.query('PillReminder');
    
    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();

    final exportData = {
      'pill_regimen': pillRegimen,
      'pill_intake': pillIntakes,
      'pill_reminder': pillReminders,
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'db_version': dbVersion,
    };

    final jsonString = jsonEncode(exportData);
    
    return jsonString;
  }

  /// Imports pill regimen, intake, and reminder data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString, AppLocalizations l10n) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('pill_regimen') || 
          !importData.containsKey('pill_intake') || 
          !importData.containsKey('pill_reminder')) 
      {
        throw const FormatException('Invalid import file: Missing one or more required pill data sections (regimen, intake, or reminder).');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      final Map<int, int> regimenIdMap = {};

      await db.transaction((txn) async {
        
        await txn.delete('PillIntake');
        await txn.delete('PillReminder');
        await txn.delete('PillRegimen');

        final List pillRegimens = importData['pill_regimen'] as List;
        for (final Map<String, dynamic> regimen in pillRegimens.cast<Map<String, dynamic>>()) {
          final int oldId = regimen['id'] as int;
          final Map<String, dynamic> dataToInsert = Map.from(regimen)..remove('id'); 
          final int newId = await txn.insert('PillRegimen', dataToInsert, conflictAlgorithm: ConflictAlgorithm.replace);
          regimenIdMap[oldId] = newId;
        }

        final List pillIntakes = importData['pill_intake'] as List;
        for (final Map<String, dynamic> intake in pillIntakes.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> dataToInsert = Map.from(intake)..remove('id');
          final int oldRegimenId = dataToInsert['regimen_id'] as int;
          dataToInsert['regimen_id'] = regimenIdMap[oldRegimenId];
          
          if (dataToInsert['regimen_id'] != null) {
            await txn.insert('PillIntake', dataToInsert, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
        
        final List pillReminders = importData['pill_reminder'] as List;
        for (final Map<String, dynamic> reminder in pillReminders.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> dataToInsert = Map.from(reminder)..remove('id'); 
          final int oldRegimenId = dataToInsert['regimen_id'] as int;
          dataToInsert['regimen_id'] = regimenIdMap[oldRegimenId];
          
          if (dataToInsert['regimen_id'] != null) {
            await txn.insert('PillReminder', dataToInsert, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      });

      await NotificationService.cancelPillReminder();

      bool pillNotificationsEnabled = false;
      TimeOfDay pillNotificationTime = const TimeOfDay(hour: 9, minute: 0);

      final activeRegimen = await pillsRepo.readActivePillRegimen(); 

      if (activeRegimen != null && activeRegimen.id != null) {
        final pillReminder = await pillsRepo.readReminderForRegimen(activeRegimen.id!);
        
        if (pillReminder != null) {
          pillNotificationsEnabled = pillReminder.isEnabled;
          final timeParts = pillReminder.reminderTime.split(':');
          pillNotificationTime = TimeOfDay(
              hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
        }
      }
      
      await NotificationService.schedulePillReminder(
        reminderTime: pillNotificationTime,
        isEnabled: pillNotificationsEnabled,
        title: l10n.notification_pillTitle,
        body: l10n.notification_pillBody,
      );
      
    } on FormatException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception('Failed to import pill data: $e');
    }
  }

  /// Deletes all entries from the pill related tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('PillRegimen');
      await txn.delete('PillIntake');
      await txn.delete('PillReminder');
    });
  }
}