import 'dart:convert';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = 'sanitary_product_logs';

class SanitaryProductRepository {
  final dbProvider = AppDatabase.instance;
  final Manager manager;

  SanitaryProductRepository() : manager = Manager(AppDatabase.instance);
  
  Future<void> logSanitaryProduct(SanitaryProductsEntry entry) async {
    final db = await dbProvider.database;
    await db.insert(dbName, entry.toMap());
  }

  Future<List<SanitaryProductsEntry>> getAllLogs() async {
    final db = await dbProvider.database;
    final maps = await db.query(dbName, orderBy: 'logTime DESC');
    return maps.map((map) => SanitaryProductsEntry.fromMap(map)).toList();
  }

  Future<SanitaryProductsEntry?> getLogById(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query(dbName, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? SanitaryProductsEntry.fromMap(maps.first) : null;
  }

  /// Returns all inactive sanitary product entries (those with removedTime not null).
  Future<List<SanitaryProductsEntry>> getInactiveLogs() async {
    final db = await dbProvider.database;
    final maps = await db.query(
      dbName,
      where: 'removedTime IS NOT NULL',
      orderBy: 'logTime DESC',
    );
    return maps.map((map) => SanitaryProductsEntry.fromMap(map)).toList();
  }

  /// Returns the currently active sanitary product entry, if any.
  /// An active entry is one where the removedTime is null.
  Future<SanitaryProductsEntry?> getActiveEntry() async {
    final db = await dbProvider.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      dbName,
      where: 'removedTime IS NULL', 
      orderBy: 'logTime DESC', 
      limit: 1,
    );

    return maps.isNotEmpty ? SanitaryProductsEntry.fromMap(maps.first) : null;
  }

  /// Marks the sanitary product entry as removed by setting the removedTime. 
  Future<void> markEntryAsRemoved(int id, DateTime removedTime) async {
    final db = await dbProvider.database;
    await db.update(
      dbName, 
      {'removedTime': removedTime.toIso8601String()}, 
      where: 'id = ?', 
      whereArgs: [id]
    );
  }

  Future<void> updateLog(SanitaryProductsEntry entry) async {
    final db = await dbProvider.database;
    await db.update(dbName, entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteLog(int id) async {
    final db = await dbProvider.database;
    await db.delete(dbName, where: 'id = ?', whereArgs: [id]);
  }
}

class Manager {
  final AppDatabase dbProvider;

  Manager(this.dbProvider);

  /// Returns Sanitary products data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final sanitaryProductsLogs = await db.query(dbName);
    
    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();

    final exportData = {
      dbName: sanitaryProductsLogs,
      'exported_at': DateTime.now().toIso8601String(),
      'app_version': packageInfo.version,
      'db_version': dbVersion,
    };

    final jsonString = jsonEncode(exportData);
    
    return jsonString;
  }

  /// Imports Sanitary products data from a JSON string.
  /// Throws an exception if the JSON format is invalid or the database version is incompatible.
  Future<void> importDataFromJson(String jsonString) async {
    final db = await dbProvider.database;

    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      if (!importData.containsKey(dbName))
      {
        throw const FormatException('Invalid import file: Missing required sanitary products data sections.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      await db.transaction((txn) async {
        
        await txn.delete(dbName);

        final List sanitaryProductsLogsRaw = importData[dbName] as List;
        for (final Map<String, dynamic> logRaw
            in sanitaryProductsLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          logToInsert.remove('id');
          
          await txn.insert(
            dbName,
            logToInsert,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } on FormatException catch (_) {
      rethrow;
    } catch (e) {
      throw Exception('Failed to import sanitary products data: $e');
    }
  }

  /// Deletes all entries from the sanitary products related tables.
  Future<void> clearAllData() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete(dbName);
    });
  }
}