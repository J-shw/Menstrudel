import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/constants.dart';
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

  PeriodService(this._settingsService, this._periodsRepo);

  bool _isLoading = true;
  List<Period> _periodEntries = [];
  List<Object> _timelineItems = [];
  PeriodPredictionResult? _predictionResult;
  int _circleCurrentValue = 0;
  int _circleMaxValue = 28;
  bool _isPeriodOngoing = false;
  int _menstruationDay = 0;

  /// Whether a background operation is currently in progress.
  bool get isLoading => _isLoading;

  /// The list of calculated [Period] objects, representing entire period cycles.
  List<Period> get periodEntries => _periodEntries;

  /// The calculated prediction for the next period, if available.
  PeriodPredictionResult? get predictionResult => _predictionResult;

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

    final oldPredictionDate = _predictionResult?.estimatedStartDate;

    try {
      _periodEntries = await _periodsRepo.readAllPeriods();

      _calculatePrediction();
      _updateUiState();
      _buildTimelineItems(currentLogs: currentLogs);

      if (l10n != null) {
        _updateWidgetData(l10n, widgetController);
        if (oldPredictionDate != _predictionResult?.estimatedStartDate) {
          _schedulePeriodNotifications(l10n);
        }
      }

      _syncWatchData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Calculates the period prediction and ongoing status.
  void _calculatePrediction() {
    _predictionResult = PeriodPredictor.estimateNextPeriod(
      _periodEntries,
      DateTime.now(),
    );

    final lastPeriod = _periodEntries.firstOrNull;
    _isPeriodOngoing =
        lastPeriod != null &&
        DateUtils.isSameDay(lastPeriod.endDate, DateTime.now());
    
    if (lastPeriod == null){
      _menstruationDay = 0;
    }else{
      final today = DateUtils.dateOnly(DateTime.now());
      final start = DateUtils.dateOnly(lastPeriod.startDate);
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
    int daysUntilDue = _predictionResult?.daysUntilDue ?? 0;
    _circleMaxValue = _predictionResult?.averageCycleLength ?? 28;
    _circleCurrentValue = daysUntilDue.clamp(0, _circleMaxValue);
  }

  /// Updates the home screen widget.
  void _updateWidgetData(AppLocalizations l10n, WidgetController controller) {
    String largeText = '$_circleCurrentValue';
    String smallText = l10n.periodPredictionCircle_days(_circleCurrentValue);

    String dateText = '';
    if (_predictionResult != null) {
      dateText =
          '${l10n.logScreen_nextPeriodEstimate}:\n ${DateFormat('MMM d').format(_predictionResult!.estimatedStartDate)}';
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
    if (_predictionResult == null) return;

    // Period due notification
    try {
      await NotificationService.schedulePeriodNotifications(
        scheduledTime: _predictionResult!.estimatedStartDate,
        areEnabled: _settingsService.areNotificationsEnabled,
        daysBefore: _settingsService.notificationDays,
        notificationTime: _settingsService.notificationTime,
        title: l10n.notification_periodTitle,
        body: l10n.notification_periodBody(_settingsService.notificationDays),
        notificationID: periodDueNotificationId,
      );
    } catch (e) {
      debugPrint('Error creating period notification: $e');
    }

    // Overdue period notification
    try {
      await NotificationService.schedulePeriodNotifications(
        scheduledTime: _predictionResult!.estimatedStartDate,
        areEnabled: _settingsService.arePeriodOverdueNotificationsEnabled,
        daysAfter: _settingsService.periodOverdueNotificationDays,
        notificationTime: _settingsService.periodOverdueNotificationTime,
        title: l10n.notification_periodOverdueTitle,
        body: l10n.notification_periodOverdueBody(
          _settingsService.periodOverdueNotificationDays,
        ),
        notificationID: periodOverdueNotificationId,
      );
    } catch (e) {
      debugPrint('Error creating period overdue notification: $e');
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
}