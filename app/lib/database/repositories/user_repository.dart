import 'dart:convert';
import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/app/user_entry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final dbProvider = AppDatabase.instance;
  final Manager manager;

  UserRepository() : manager = Manager(AppDatabase.instance);

  /// Saves or updates the user data.
  Future<void> saveUser(UserEntry user) async {
    final db = await dbProvider.database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserEntry?> getUser() async {
    final db = await dbProvider.database;
    final maps = await db.query('user', where: 'id = ?', whereArgs: [UserEntry.singletonId]);
    
    if (maps.isEmpty) return null;
    return UserEntry.fromMap(maps.first);
  }

  Future<void> deleteUser() async {
    final db = await dbProvider.database;
    await db.delete('user', where: 'id = ?', whereArgs: [UserEntry.singletonId]);
  }

  Future<void> setOnboardingComplete() async {
    final db = await dbProvider.database;
    await db.update(
      'user', 
      {'onboarding_complete': 1},
      where: 'id = ?',
      whereArgs: [UserEntry.singletonId],
    );
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

    return jsonEncode(exportData);
  }

  /// Imports User data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('user')) {
        throw const FormatException('Invalid import file.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version.');
      }

      await db.transaction((txn) async {
        await txn.delete('user');

        final List userList = importData['user'] as List;
        if (userList.isNotEmpty) {
          final Map<String, dynamic> userData = Map.from(userList.first);
          
          userData['id'] = UserEntry.singletonId;

          await txn.insert(
            'user',
            userData,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      throw Exception('Failed to import User data: $e');
    }
  }

  /// Deletes all entries from the User related tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.delete('user');
  }
}