import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/period_logger_service.dart';
import 'package:menstrudel/services/wear_sync_service.dart';
import 'package:menstrudel/services/widget_controller.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/dialogs/tampon_reminder_dialog.dart';

class PeriodService extends ChangeNotifier {
  final SettingsService _settingsService;
  final _periodsRepo = PeriodsRepository();
  final _watchSyncService = WatchSyncService();

  PeriodService(this._settingsService);

  bool _isLoading = true;
  List<PeriodDay> _periodLogEntries = [];
  List<Period> _periodEntries = [];
  PeriodPredictionResult? _predictionResult;
  PeriodHistoryView _selectedView = PeriodHistoryView.journal;
  int _circleCurrentValue = 0;
  int _circleMaxValue = 28;
  bool _isTamponReminderSet = false;
  bool _isPeriodOngoing = false;

  bool get isLoading => _isLoading;
  List<PeriodDay> get periodLogEntries => _periodLogEntries;
  List<Period> get periodEntries => _periodEntries;
  PeriodPredictionResult? get predictionResult => _predictionResult;
  PeriodHistoryView get selectedView => _selectedView;
  int get circleCurrentValue => _circleCurrentValue;
  int get circleMaxValue => _circleMaxValue;
  bool get isTamponReminderSet => _isTamponReminderSet;
  bool get isPeriodOngoing => _isPeriodOngoing;

  /// Loads all initial data and performs calculations.
  /// Should be called once when the screen is first initialised.
  Future<void> loadInitialData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final l10n = AppLocalizations.of(context)!;
    final controller = Provider.of<WidgetController>(context, listen: false);

    await _fetchDataFromDb();
    _calculatePrediction();
    _updateUiState();
    _updateWidgetData(l10n, controller);
    _schedulePeriodNotifications(l10n);
    _syncWatchData();

    _isLoading = false;
    notifyListeners();
  }

  /// Refreshes all data after a user action (log, delete, etc.)
  Future<void> _refreshData(BuildContext context) async {
    final oldPredictionDate = _predictionResult?.estimatedStartDate;

    final l10n = AppLocalizations.of(context)!;
    final controller = Provider.of<WidgetController>(context, listen: false);

    await _fetchDataFromDb();
    _calculatePrediction();
    _updateUiState();
    _updateWidgetData(l10n, controller);

    // Only update notifications if the prediction date actually changed
    if (oldPredictionDate != _predictionResult?.estimatedStartDate) {
      _schedulePeriodNotifications(l10n);
    }

    _syncWatchData();
    notifyListeners();
  }

  /// Fetches all period and log data from the repository.
  Future<void> _fetchDataFromDb() async {
    _periodLogEntries = await _periodsRepo.readAllPeriodLogs();
    _periodEntries = await _periodsRepo.readAllPeriods();
    _isTamponReminderSet = await NotificationService.isTamponReminderScheduled();
    _selectedView = _settingsService.historyView;
  }

  /// Calculates the period prediction and ongoing status.
  void _calculatePrediction() {
    _predictionResult = PeriodPredictor.estimateNextPeriod(_periodEntries, DateTime.now());
    _isPeriodOngoing = _periodEntries.isNotEmpty &&
        DateUtils.isSameDay(_periodEntries.first.endDate, DateTime.now());
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

    controller.saveAndAndUpdateCircle(
      currentValue: _circleCurrentValue,
      maxValue: _circleMaxValue,
      largeText: largeText,
      smallText: smallText,
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
        body: l10n.notification_periodOverdueBody(_settingsService.periodOverdueNotificationDays),
        notificationID: periodOverdueNotificationId,
      );
    } catch (e) {
      debugPrint('Error creating period overdue notification: $e');
    }
  }

  /// Syncs circle data with the Wear OS watch.
  Future<void> _syncWatchData() async {
    await _watchSyncService.sendCircleData(
      circleMaxValue: _circleMaxValue,
      circleCurrentValue: _circleCurrentValue,
    );
  }

  /// Creates a new log entry.
  Future<void> createNewLog(BuildContext context, DateTime selectedDate) async {
    final bool wasLogSuccessful = await PeriodLoggerService.showAndLogPeriod(context, selectedDate);

    if (wasLogSuccessful && context.mounted) {
      _isLoading = true;
      notifyListeners();
      await _refreshData(context);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates an existing log entry.
  Future<void> updateExistingLog(BuildContext context, PeriodDay updatedLog) async {
    await _periodsRepo.updatePeriodLog(updatedLog);
    
    if (context.mounted) {
      Navigator.of(context).pop();
      _isLoading = true;
      notifyListeners();
      await _refreshData(context);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a log entry.
  Future<void> deleteExistingLog(BuildContext context, int? id) async {
    if (id == null) return;

    await _periodsRepo.deletePeriodLog(id);
    
    _isLoading = true;
    notifyListeners();
    if(context.mounted){
      await _refreshData(context);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Shows the dialog and schedules a tampon reminder.
  Future<void> handleTamponReminder(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final reminderDateTime = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) => const TimeSelectionDialog(),
    );

    if (reminderDateTime == null) return;

    await NotificationService.scheduleTamponReminder(
      reminderDateTime: reminderDateTime,
      title: l10n.notification_tamponReminderTitle,
      body: l10n.notification_tamponReminderBody,
    );
    
    await NotificationService.setTamponReminderScheduledTime(reminderDateTime);

    if (context.mounted) {
      final formattedTime = TimeOfDay.fromDateTime(reminderDateTime).format(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${l10n.logScreen_tamponReminderSetFor} $formattedTime')));
        
      _isTamponReminderSet = true;
      notifyListeners();
    }
  }

  /// Cancels an active tampon reminder.
  Future<void> handleCancelReminder(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await NotificationService.cancelTamponReminder();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.logScreen_tamponReminderCancelled)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.logScreen_couldNotCancelReminder}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      _isTamponReminderSet = false;
      notifyListeners();
    }
  }
}