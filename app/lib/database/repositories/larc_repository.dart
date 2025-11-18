import 'package:menstrudel/database/app_database.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';

class LarcRepository {
  final dbProvider = AppDatabase.instance;
  
  Future<void> logLarc(LarcLogEntry entry) async {
    final db = await dbProvider.database;
    await db.insert('larc_logs', entry.toMap());
  }
}