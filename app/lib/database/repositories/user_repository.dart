import 'dart:convert';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/app/user_entry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final dbProvider = AppDatabase.instance;

  final Manager manager;

  UserRepository() : manager = Manager(AppDatabase.instance);

  Future<void> createUser(UserEntry user) async {
    final db = await dbProvider.database;
    await db.insert('user', user.toMap());
  }

  Future<UserEntry?> getUser() async {
    final db = await dbProvider.database;
    final maps = await db.query('user', limit: 1);
    
    if (maps.isEmpty) return null;
    return UserEntry.fromMap(maps.first);
  }

  Future<void> updateUser(UserEntry user) async {
    if (user.id == null) return;
    
    final db = await dbProvider.database;
    await db.update(
      'user',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await dbProvider.database;
    await db.delete('user', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> setOnboardingComplete() async {
    final db = await dbProvider.database;
    await db.update('user', {'onboarding_complete': 1});
  }
}

class Manager {
  final AppDatabase dbProvider;

  Manager(this.dbProvider);

  /// Returns User data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final user = await db.query('user');
    
    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();

    final exportData = {
      'user': user,
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'db_version': dbVersion,
    };

    final jsonString = jsonEncode(exportData);
    
    return jsonString;
  }

  /// Imports User data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('user')) {
        throw const FormatException('Invalid import file: Missing required user data sections.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      await db.transaction((txn) async {
        
        await txn.delete('user');

        final List userLogsRaw = importData['user'] as List;
        for (final Map<String, dynamic> logRaw
            in userLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          logToInsert.remove('id');
          
          await txn.insert(
            'user',
            logToInsert,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } on FormatException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception('Failed to import User data: $e');
    }
  }

  /// Deletes all entries from the User related tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('user');
    });
  }
}