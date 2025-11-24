import 'dart:convert';

import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

class SanitaryProductRepository {
  final dbProvider = AppDatabase.instance;

  final Manager manager;

  SanitaryProductRepository() : manager = Manager(AppDatabase.instance);
  
  Future<void> logSanitaryProduct(SanitaryProductsEntry entry) async {
    final db = await dbProvider.database;
    await db.insert('sanitary_product_logs', entry.toMap());
  }

  Future<List<SanitaryProductsEntry>> getAllLogs() async {
    final db = await dbProvider.database;
    final maps = await db.query('sanitary_product_logs', orderBy: 'date DESC');
    return maps.map((map) => SanitaryProductsEntry.fromMap(map)).toList();
  }

  Future<SanitaryProductsEntry?> getLogById(int id) async {
    final db = await dbProvider.database;
    final maps = await db.query('sanitary_product_logs', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? SanitaryProductsEntry.fromMap(maps.first) : null;
  }

  Future<void> updateLog(SanitaryProductsEntry entry) async {
    final db = await dbProvider.database;
    await db.update('sanitary_product_logs', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<void> deleteLog(int id) async {
    final db = await dbProvider.database;
    await db.delete('sanitary_product_logs', where: 'id = ?', whereArgs: [id]);
  }
}

class Manager {
  final AppDatabase dbProvider;

  Manager(this.dbProvider);

  /// Returns Sanitary products data as json - ready for exporting data.
  Future<String> exportDataAsJson() async {
    final db = await dbProvider.database;

    final sanitaryProductsLogs = await db.query('sanitary_product_logs');
    
    final packageInfo = await PackageInfo.fromPlatform();
    final dbVersion = await db.getVersion();

    final exportData = {
      'sanitary_product_logs': sanitaryProductsLogs,
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

      if (!importData.containsKey('sanitary_product_logs'))
      {
        throw const FormatException('Invalid import file: Missing required sanitary products data sections.');
      }
      
      final importedDbVersion = importData['db_version'] as int?;
      final currentDbVersion = await db.getVersion();

      if (importedDbVersion != null && importedDbVersion > currentDbVersion) {
        throw FormatException('Incompatible database version: Imported data is from v$importedDbVersion, but current database is v$currentDbVersion. Please update the app.');
      }

      await db.transaction((txn) async {
        
        await txn.delete('sanitary_product_logs');

        final List sanitaryProductsLogsRaw = importData['sanitary_product_logs'] as List;
        for (final Map<String, dynamic> logRaw
            in sanitaryProductsLogsRaw.cast<Map<String, dynamic>>()) {
          final Map<String, dynamic> logToInsert = Map.from(logRaw);

          logToInsert.remove('id');
          
          await txn.insert(
            'sanitary_product_logs',
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
      await txn.delete('sanitary_product_logs');
    });
  }
}