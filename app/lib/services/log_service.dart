import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';

class LogService extends ChangeNotifier {
  final LogsRepository _logRepo;
  
  LogService(this._logRepo);

  List<LogDay> _logs = [];
  Map<DateTime, LogDay> _logMap = {};
  DateTime? _earliestLogDate;
  DateTime? _latestLogDate;
  bool _isLoading = false;


  /// The complete list of all individual period day logs.
  List<LogDay> get logs => _logs;
  /// A pre-computed map of logs, keyed by their date, for fast calendar lookups.
  Map<DateTime, LogDay> get logMap => _logMap;
  /// The date of the earliest log on record.
  DateTime? get earliestLogDate => _earliestLogDate;
  /// The date of the latest log on record.
  DateTime? get latestLogDate => _latestLogDate;
  /// Whether a background operation is currently in progress.
  bool get isLoading => _isLoading;

  /// Loads all logs for the views.
  Future<void> loadLogs() async {
    _isLoading = true;
    notifyListeners();

    _logs = await _logRepo.readAllLogs();
    _processJournalData();

    _isLoading = false;
    notifyListeners();
  }

  /// Populates the map and date boundaries for the Journal view.
  void _processJournalData() {
    if (_logs.isEmpty) {
      _logMap = {};
      _earliestLogDate = null;
      _latestLogDate = null;
      return;
    }

    _logMap = {
      for (var log in _logs) DateUtils.dateOnly(log.date): log
    };
    
    _earliestLogDate = _logs
        .reduce((a, b) => a.date.isBefore(b.date) ? a : b)
        .date;
    _latestLogDate = _logs
        .reduce((a, b) => a.date.isAfter(b.date) ? a : b)
        .date;
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