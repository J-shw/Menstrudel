import 'dart:convert';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class LarcRepository {
  final dbProvider = AppDatabase.instance;

  final Manager manager;

  LarcRepository() : manager = Manager(AppDatabase.instance);
  
  Future<void> logLarc(LarcLogEntry entry) async {
    final db = await dbProvider.database;
    await db.insert('larc_logs', entry.toMap());
  }

  Future<List<LarcLogEntry>> getAllLogs() async {
    final db = await dbProvider.database;
    final maps = await db.query('larc_logs', orderBy: 'date DESC');
    return maps.map((map) => LarcLogEntry.fromMap(map)).toList();
  }

  Future<LarcLogEntry?> getLogById(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query('larc_logs', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? LarcLogEntry.fromMap(maps.first) : null;
  }

  Future<void> updateLog(LarcLogEntry entry) async {
    final db = await dbProvider.database;
    await db.update('larc_logs', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteLog(int id) async {
    final db = await dbProvider.database;
    await db.delete('larc_logs', where: 'id = ?', whereArgs: [id]);
  }
}

class Manager {
  final AppDatabase dbProvider;

  Manager(this.dbProvider);

  /// Returns LARCs data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final larcLogs = await db.query('larc_logs');
    
    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();

    final exportData = {
      'larc_logs': larcLogs,
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'db_version': dbVersion,
    };

    final jsonString = jsonEncode(exportData);
    
    return jsonString;
  }

  /// Imports LARC data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey('larc_logs'))
      {
        throw const FormatException('Invalid import file: Missing required larcs data sections.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      await db.transaction((txn) async {
        
        await txn.delete('larc_logs');

        final List larcLogsRaw = importData['larc_logs'] as List;
        for (final Map<String, dynamic> logRaw
            in larcLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          logToInsert.remove('id');
          
          await txn.insert(
            'larc_logs',
            logToInsert,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } on FormatException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception('Failed to import LARC data: $e');
    }
  }

  /// Deletes all entries from the LARC related tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('larc_logs');
    });
  }
}