import 'dart:convert';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class SexRepository {
  final dbProvider = AppDatabase.instance;

  final Manager manager;

  SexRepository() : manager = Manager(AppDatabase.instance);
  
  Future<void> logActivity(SexLogEntry entry) async {
    final db = await dbProvider.database;
    await db.insert('sexual_activity_logs', entry.toMap());
  }

  Future<List<SexLogEntry>> getAllLogs() async {
    final db = await dbProvider.database;
    final maps = await db.query('sexual_activity_logs', orderBy: 'date_time DESC');
    return maps.map((map) => SexLogEntry.fromMap(map)).toList();
  }

  Future<SexLogEntry?> getLogById(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query('sexual_activity_logs', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? SexLogEntry.fromMap(maps.first) : null;
  }

  Future<void> updateLog(SexLogEntry entry) async {
    final db = await dbProvider.database;
    await db.update('sexual_activity_logs', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteLog(int id) async {
    final db = await dbProvider.database;
    await db.delete('sexual_activity_logs', where: 'id = ?', whereArgs: [id]);
  }
}

class Manager {
  final AppDatabase dbProvider;

  Manager(this.dbProvider);

  /// Returns Sex data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final sexLogs = await db.query('sexual_activity_logs');
    
    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();

    final exportData = {
      'sexual_activity_logs': sexLogs,
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'db_version': dbVersion,
    };

    final jsonString = jsonEncode(exportData);
    
    return jsonString;
  }

  /// Imports Sex data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('sexual_activity_logs'))
      {
        throw const FormatException('Invalid import file: Missing required sexual activity logs data sections.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      await db.transaction((txn) async {
        
        await txn.delete('sexual_activity_logs');

        final List sexLogsRaw = importData['sexual_activity_logs'] as List;
        for (final Map<String, dynamic> logRaw
            in sexLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          logToInsert.remove('id');
          
          await txn.insert(
            'sexual_activity_logs',
            logToInsert,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } on FormatException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception('Failed to import Sex data: $e');
    }
  }

  /// Deletes all entries from the Sex related tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('sexual_activity_logs');
    });
  }
}