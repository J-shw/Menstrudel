import 'package:flutter/material.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase.dart';
import 'package:menstrudel/models/flows/flow_data.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/cycle_phase_predictor.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/wear_sync_service.dart';
import 'package:menstrudel/services/widget_controller.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class PeriodService extends ChangeNotifier {
  final SettingsService _settingsService;
  final PeriodsRepository _periodsRepo;
  final _watchSyncService = WatchSyncService();

  /// The maximum number of recent months to consider when calculating cycle statistics.
  static const int _lastNMonthsToConsider = 6;

  PeriodService(this._settingsService, this._periodsRepo);

  bool _isLoading = true;
  List<Period> _periodEntries = [];
  Period? _lastPeriod;
  List<Object> _timelineItems = [];
  PeriodPredictionResult? _upcomingPeriodPrediction;
  PeriodPredictionResult? _followingPeriodPrediction;
  PredictedCycle? _predictedCurrentCycle;
  int _circleCurrentValue = 0;
  int _circleMaxValue = 28;
  bool _isPeriodOngoing = false;
  int _menstruationDay = 0;

  /// Whether a background operation is currently in progress.
  bool get isLoading => _isLoading;

  /// The list of calculated [Period] objects, representing entire period cycles.
  List<Period> get periodEntries => _periodEntries;

  /// The most recent period entry, or null if no periods are logged.
  Period? get lastPeriod => _lastPeriod;

  /// Prediction for the immediate next period.
  PeriodPredictionResult? get upcomingPeriodPrediction => _upcomingPeriodPrediction;

  /// Prediction for the period after the next one.
  PeriodPredictionResult? get followingPeriodPrediction => _followingPeriodPrediction;

  /// The calculated phase predictions for current cycle.
  PredictedCycle? get predictedCurrentCycle => _predictedCurrentCycle;

  /// The current value for the main progress circle (e.g., days until due).
  int get circleCurrentValue => _circleCurrentValue;

  /// The maximum value for the main progress circle (e.g., average cycle length).
  int get circleMaxValue => _circleMaxValue;

  /// Whether the user's period is considered to be ongoing today.
  bool get isPeriodOngoing => _isPeriodOngoing;

  /// The number of days since current period started.
  int get menstruationDay => _menstruationDay;

  /// A pre-computed list of timeline items for the PeriodListView.
  List<Object> get timelineItems => _timelineItems;

  /// Refreshes all period-related data, predictions, notifications, and widgets.
  Future<void> refreshData({
    required List<LogDay> currentLogs,
    AppLocalizations? l10n,
    required WidgetController widgetController,
  }) async {
    debugPrint('PeriodService: Starting data refresh.');

    if (_isLoading && _periodEntries.isNotEmpty) return;

    _isLoading = true;

    notifyListeners();

    final oldCyclePredictionFertileStart = _predictedCurrentCycle?.fertileWindowStart;
    final oldCyclePredictionOvulationDay = _predictedCurrentCycle?.ovulationDay;

    try {
      _periodEntries = await _periodsRepo.readAllPeriods();
      _lastPeriod = _periodEntries.firstOrNull;

      await _calculatePrediction();
      _updateUiState();
      _buildTimelineItems(currentLogs: currentLogs);

      if (l10n != null) {
        _updateWidgetData(l10n, widgetController);
        _schedulePeriodNotifications(l10n);

        if (_predictedCurrentCycle != null && _settingsService.isNaturalCycle){
          if (oldCyclePredictionFertileStart != _predictedCurrentCycle?.fertileWindowStart && _settingsService.areFertileWindowNotificationsEnabled) {
            _scheduleFertileWindowNotification(l10n);
          } 
          if (oldCyclePredictionOvulationDay != _predictedCurrentCycle?.ovulationDay && _settingsService.areOvulationNotificationsEnabled) {
            _scheduleOvulationDayNotification(l10n);
          }
        }
      }
      if(!_settingsService.isNaturalCycle){
        NotificationService.cancelFertileWindowNotification();
        NotificationService.cancelOvulationNotification();
      }
      _syncWatchData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculates the period predictions, cycle predictions and ongoing status.
  Future<void> _calculatePrediction() async {
    final periods = await getPeriodsSince(DateTime.now().subtract(const Duration(days: _lastNMonthsToConsider * 30)));

    _upcomingPeriodPrediction = PeriodPredictor.estimateNextPeriod(
      periods,
      DateTime.now(),
    );

    _isPeriodOngoing = _lastPeriod != null ? DateUtils.isSameDay(_lastPeriod!.endDate, DateTime.now()) : false;
    
    if (_upcomingPeriodPrediction != null && _lastPeriod != null) {
      final lastPeriodStartDate = _lastPeriod!.startDate;
      final averageCycleLength = _upcomingPeriodPrediction?.averageCycleLength ?? 0;
      final averagePeriodDuration = _upcomingPeriodPrediction?.averagePeriodDuration ?? 0;
      
      _predictedCurrentCycle = CyclePhasePredictor.predictCycle(
        lastPeriodStartDate: lastPeriodStartDate, 
        averageCycleLength: averageCycleLength, 
        averagePeriodDuration: averagePeriodDuration
      );

      final estimatedFollowingPeriodStartDate = _upcomingPeriodPrediction!.estimatedStartDate.add(
        Duration(days: averageCycleLength),
      );
      final estimatedFollowingPeriodEndDate = estimatedFollowingPeriodStartDate.add(
        Duration(days: averagePeriodDuration -1),
      );
      final estimatedFollowingPeriodDaysUntilDue = estimatedFollowingPeriodStartDate.difference(DateTime.now()).inDays;
      

      _followingPeriodPrediction = PeriodPredictionResult(
        estimatedStartDate: estimatedFollowingPeriodStartDate,
        estimatedEndDate: estimatedFollowingPeriodEndDate, 
        daysUntilDue: estimatedFollowingPeriodDaysUntilDue, 
        averageCycleLength: averageCycleLength, 
        averagePeriodDuration: averagePeriodDuration
      );
    }else{
      _predictedCurrentCycle = null;
      _followingPeriodPrediction = null;
    }


    if (lastPeriod == null){
      _menstruationDay = 0;
    }else{
      final today = DateUtils.dateOnly(DateTime.now());
      final start = DateUtils.dateOnly(_lastPeriod!.startDate);
      _menstruationDay = today.difference(start).inDays + 1;
    }
  }

  /// Recalculates periods based on the provided [logs] and returns a mapping of log IDs to period IDs.
  Future<Map<int, int>> recalculatePeriods(List<LogDay> logs) async {
    final mapping = await _periodsRepo.recalculateAndAssignPeriods(logs);    
    return mapping;
  }

  /// Updates the circle and FAB state variables.
  void _updateUiState() {
    int daysUntilDue = _upcomingPeriodPrediction?.daysUntilDue ?? 0;
    _circleMaxValue = _upcomingPeriodPrediction?.averageCycleLength ?? 28;
    _circleCurrentValue = daysUntilDue.clamp(0, _circleMaxValue);
  }

  /// Updates the home screen widget.
  void _updateWidgetData(AppLocalizations l10n, WidgetController controller) {
    String largeText = '$_circleCurrentValue';
    String smallText = l10n.periodPredictionCircle_days(_circleCurrentValue);

    String dateText = '';
    if (_upcomingPeriodPrediction != null) {
      dateText =
          '${l10n.logScreen_nextPeriodEstimate}:\n ${DateFormat('MMM d').format(_upcomingPeriodPrediction!.estimatedStartDate)}';
    }
    controller.saveAndAndUpdateCircle(
      currentValue: _circleCurrentValue,
      maxValue: _circleMaxValue,
      largeText: largeText,
      smallText: smallText,
      predictionDate: dateText,
    );
  }

  /// Schedules period due and overdue notifications.
  Future<void> _schedulePeriodNotifications(AppLocalizations l10n) async {
    if (_upcomingPeriodPrediction == null) return;

    // Period due notification
    if (_settingsService.arePeriodDueNotificationsEnabled){
      try {
        await NotificationService.schedulePeriodNotifications(
          scheduledTime: _upcomingPeriodPrediction!.estimatedStartDate,
          daysBefore: _settingsService.notificationDays,
          notificationTime: _settingsService.notificationTime,
          title: l10n.notification_periodTitle,
          body: l10n.notification_periodBody(_settingsService.notificationDays)
        );
      } catch (e) {
        debugPrint('Error creating period notification: $e');
      }
    }

    // Overdue period notification
    if (_settingsService.arePeriodOverdueNotificationsEnabled){
      try {
        await NotificationService.schedulePeriodNotifications(
          scheduledTime: _upcomingPeriodPrediction!.estimatedStartDate,
          daysAfter: _settingsService.periodOverdueNotificationDays,
          notificationTime: _settingsService.periodOverdueNotificationTime,
          title: l10n.notification_periodOverdueTitle,
          body: l10n.notification_periodOverdueBody(
            _settingsService.periodOverdueNotificationDays,
          )
        );
      } catch (e) {
        debugPrint('Error creating period overdue notification: $e');
      }
    }
  }

  /// Schedules fertile window notification.
  Future<void> _scheduleFertileWindowNotification(AppLocalizations l10n) async {
    try {
      await NotificationService.scheduleFertileWindowNotification(
        scheduledTime: _predictedCurrentCycle!.fertileWindowStart,
        daysBefore: _settingsService.fertileWindowReminderDaysBefore,
        notificationTime: _settingsService.fertileWindowReminderTime,
        title: l10n.notification_fertileWindowTitle,
        body: l10n.notification_fertileWindowBody(_settingsService.fertileWindowReminderDaysBefore),
      );
    } catch (e) {
      debugPrint('Error creating fertile window notification: $e');
    }
  }

  /// Schedules ovulation day notification.
  Future<void> _scheduleOvulationDayNotification(AppLocalizations l10n) async {
    try {
      await NotificationService.scheduleOvulationNotification(
        scheduledTime: _predictedCurrentCycle!.ovulationDay,
        daysBefore: _settingsService.ovulationReminderDays,
        notificationTime: _settingsService.ovulationReminderTime,
        title: l10n.notification_ovulationDayReminderTitle,
        body: l10n.notification_ovulationDayReminderBody(_settingsService.ovulationReminderDays),
      );
    } catch (e) {
      debugPrint('Error creating fertile window notification: $e');
    }
  }

  /// Schedules a logging reminder from a [LogDay] object.
  Future<void> scheduleLoggingReminder({
    required LogDay log,
    required SettingsService settings,
    required AppLocalizations l10n,
  }) async {
    if (log.flow == FlowRate.none) {
      await NotificationService.cancelLoggingReminder(log.date);
    } else if (log.flow != FlowRate.none) {
      final nextDay = log.date.add(const Duration(days: 1));
      final reminderTime = settings.loggingReminderTime;
      final bool isReminderEnabled =
          settings.isLoggingReminderNotificationEnabled;

      final scheduledTime = DateTime(
        nextDay.year,
        nextDay.month,
        nextDay.day,
        reminderTime.hour,
        reminderTime.minute,
      );

      NotificationService.scheduleLoggingReminder(
        scheduledTime: scheduledTime,
        isEnabled: isReminderEnabled,
        title: l10n.notification_loggingReminderTitle,
        body: l10n.notification_loggingReminderBody,
      );
    }
  }

  /// Syncs circle data with the Wear OS watch.
  Future<void> _syncWatchData() async {
    await _watchSyncService.sendCircleData(
      circleMaxValue: _circleMaxValue,
      circleCurrentValue: _circleCurrentValue,
    );
  }

  /// Populates the [_timelineItems] list for the list view.
  void _buildTimelineItems({required List<LogDay> currentLogs}) {
    final logsByPeriod = groupBy(currentLogs, (log) => log.periodId);

    final List<Object> standaloneEvents = [
      ..._periodEntries,
      ...currentLogs.where((log) => log.periodId == null || log.periodId == -1),
    ];

    final groupedByMonth = groupBy<Object, DateTime>(standaloneEvents, (event) {
      final date = event is Period ? event.startDate : (event as LogDay).date;
      return DateTime(date.year, date.month);
    });

    final sortedMonths = groupedByMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    final List<Object> items = [];

    for (final month in sortedMonths) {
      items.add(month);

      final monthEvents = groupedByMonth[month]!
        ..sort((a, b) {
          final dateA = a is Period ? a.startDate : (a as LogDay).date;
          final dateB = b is Period ? b.startDate : (b as LogDay).date;
          return dateB.compareTo(dateA);
        });

      for (final event in monthEvents) {
        items.add(event);

        if (event is Period) {
          final childLogs = (logsByPeriod[event.id] ?? [])
            ..sort((a, b) => b.date.compareTo(a.date));

          items.addAll(childLogs);
        }
      }
    }
    _timelineItems = items;
  }

  /// Fetches periods starting from a specific date.
  Future<List<Period>> getPeriodsSince(DateTime date) async {
    return _periodsRepo.readPeriodsSince(date);
  }

  /// Fetches monthly flow data exclusively from logs that are part of a period.
  Future<List<MonthlyFlowData>> getMonthlyPeriodFlowsSince(DateTime date) async {
    return _periodsRepo.getMonthlyPeriodFlowsSince(date);
  }
}