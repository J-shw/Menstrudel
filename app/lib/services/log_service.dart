import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';

class LogService extends ChangeNotifier {
  final LogsRepository _logRepo;
  
  LogService(this._logRepo) {
    loadLogs();
  }

  List<LogDay> _logs = [];
  Map<DateTime, LogDay> _logMap = {};
  DateTime? _earliestLogDate;
  DateTime? _latestLogDate;
  bool _isLoading = false;
  bool _hasLoadedOnce = false;

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
  /// Whether logs have been loaded at least once since startup.
  bool get hasLoadedOnce => _hasLoadedOnce;

  /// Loads all logs for the views.
  Future<void> loadLogs() async {
    if (_isLoading) return;

    debugPrint('LogService: Starting loadLogs.');

    _isLoading = true;
    notifyListeners();

    _logs = await _logRepo.readAllLogs();
    _processJournalData();

    _isLoading = false;
    _hasLoadedOnce = true;
    
    notifyListeners();
  }

  /// Updates the period ID references for logs based on the provided [mapping].
  Future<void> updateLogPeriodReferences(Map<int, int> mapping) async {
    await _logRepo.updateLogPeriodIds(mapping);
    for (var log in logs) {
      log.periodId = mapping[log.id] ?? -1;
    }

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
    
    _earliestLogDate = _logs.isEmpty ? null : _logs
        .reduce((a, b) => a.date.isBefore(b.date) ? a : b)
        .date;
        
    _latestLogDate = _logs.isEmpty ? null : _logs
        .reduce((a, b) => a.date.isAfter(b.date) ? a : b)
        .date;
  }

  Future<int> saveLog(LogDay log) async {
    final id = await _logRepo.upsertLog(log);
    await loadLogs();
    return id;
  }

  Future<void> deleteLog(int id) async {
    await _logRepo.deleteLog(id);
    await loadLogs();
  }

  /// Fetches logs starting from a specific date.
  Future<List<LogDay>> getLogsSince(DateTime date) async {
    return _logRepo.readLogsSince(date);
  }

  /// Fetches the frequency of symptoms starting from a specific date for insights purposes.
  Future<Map<Symptom, int>> getSymptomFrequencySince(DateTime date) async {
    return _logRepo.getSymptomFrequencySince(date);
  }
}