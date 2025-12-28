import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';

class LogService extends ChangeNotifier {
  final LogsRepository _logRepo;
  
  LogService(this._logRepo);

  List<LogDay> _logs = [];
  Map<DateTime, LogDay> _logMap = {};
  bool _isLoading = false;

  /// The complete list of all individual period day logs.
  List<LogDay> get logs => _logs;
  /// A pre-computed map of logs, keyed by their date, for fast calendar lookups.
  Map<DateTime, LogDay> get logMap => _logMap;
  /// Whether a background operation is currently in progress.
  bool get isLoading => _isLoading;

  /// Loads all logs for the views.
  Future<void> loadLogs() async {
    _isLoading = true;
    notifyListeners();

    _logs = await _logRepo.readAllLogs();
    _logMap = {
      for (var log in _logs) DateUtils.dateOnly(log.date): log
    };

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveLog(LogDay log) async {
    await _logRepo.upsertLog(log);
    await loadLogs();
  }

  Future<void> deleteLog(int id) async {
    await _logRepo.deleteLog(id);
    await loadLogs();
  }
}