import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';

class LarcRepository {
  final dbProvider = AppDatabase.instance;
  
  Future<void> logLarc(LarcLogEntry entry) async {
    final db = await dbProvider.database;
    await db.insert('larc_logs', entry.toMap());
  }

  Future<List<LarcLogEntry>> getAllLogs() async {
    final db = await dbProvider.database;
    final maps = await db.query('larc_logs', orderBy: 'date DESC');
    return maps.map((map) => LarcLogEntry.fromMap(map)).toList();
  }
}