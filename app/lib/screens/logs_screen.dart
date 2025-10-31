import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/utils/constants.dart';

import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/dialogs/tampon_reminder_dialog.dart';
import 'package:menstrudel/screens/main_screen.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/period_logger_service.dart';
import 'package:menstrudel/widgets/logs/dynamic_history_view.dart';
import 'package:menstrudel/services/wear_sync_service.dart';
import 'package:menstrudel/widgets/sheets/period_details_bottom_sheet.dart';
import 'package:menstrudel/widgets/dialogs/reminder_countdown_dialog.dart';

import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:provider/provider.dart';


class LogsScreen extends StatefulWidget {
  final Function(FabState) onFabStateChange;
  final bool isReminderButtonAlwaysVisible;

	const LogsScreen({
    super.key,
    required this.onFabStateChange,
    required this.isReminderButtonAlwaysVisible,
  });

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  final periodsRepo = PeriodsRepository();
  late SettingsService _settingsService;

  final _watchSyncService = WatchSyncService();

	List<PeriodDay> _periodLogEntries = [];
  List<Period> _periodEntries = [];
	bool _isLoading = true;
	PeriodPredictionResult? _predictionResult;
  PeriodHistoryView _selectedView = PeriodHistoryView.journal;
  int _circleCurrentValue = 0;
  int _circleMaxValue = 28;

  Future<void> handleTamponReminderCountdown() async {
    final dueDate = await NotificationService.getTamponReminderScheduledTime();

    if (dueDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.logScreen_couldNotCancelReminder)),
        );
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ReminderCountdownDialog(
          dueDate: dueDate,
          onDelete: handleCancelReminder,
        ),
      );
    }
  }
  
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
        
      _refreshPeriodLogs();
    }
  }

  Future<void> handleCancelReminder() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await NotificationService.cancelTamponReminder();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.logScreen_tamponReminderCancelled)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.logScreen_couldNotCancelReminder}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      _refreshPeriodLogs();
    }
  }

  void _showDetailsBottomSheet(PeriodDay log) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return PeriodDetailsBottomSheet(
          log: log,
          onDelete: () => _deleteExistingLog(log.id),
          onSave: _updateExistingLog,
        );
      },
    );
  }

	@override
	void initState() {
		super.initState();
    _settingsService = context.read<SettingsService>();
		_refreshPeriodLogs();
	}

	Future<void> _refreshPeriodLogs() async {
    final periodDays = await periodsRepo.readAllPeriodLogs();
    final periods = await periodsRepo.readAllPeriods();
    final isReminderSet = await NotificationService.isTamponReminderScheduled();
    final predictionResult = PeriodPredictor.estimateNextPeriod(periods, DateTime.now());
    final selectedView = _settingsService.historyView;

    if (predictionResult != null) {
      final periodNotificationsEnabled = _settingsService.areNotificationsEnabled;
      final periodNotificationDays = _settingsService.notificationDays;
      final periodNotificationTime = _settingsService.notificationTime;

      final periodOverdueNotificationsEnabled = _settingsService.areNotificationsEnabled;
      final periodOverdueNotificationDays = _settingsService.periodOverdueNotificationDays;
      final periodOverdueNotificationTime = _settingsService.periodOverdueNotificationTime;

      if (mounted){
        final l10n = AppLocalizations.of(context)!;

        // Period due notification
        try {
          await NotificationService.schedulePeriodNotifications(
            scheduledTime: predictionResult.estimatedStartDate,
            areEnabled: periodNotificationsEnabled,
            daysBefore: periodNotificationDays,
            notificationTime: periodNotificationTime,
            title: l10n.notification_periodTitle,
            body: l10n.notification_periodBody(periodNotificationDays),
            notificationID: periodDueNotificationId,
          );
        } catch (e) {
          debugPrint('Error creating period notification: $e');
        }

        // Overdue period notification
        try {
          await NotificationService.schedulePeriodNotifications(
            scheduledTime: predictionResult.estimatedStartDate,
            areEnabled: periodOverdueNotificationsEnabled,
            daysAfter: periodOverdueNotificationDays,
            notificationTime: periodOverdueNotificationTime,
            title: l10n.notification_periodOverdueTitle,
            body: l10n.notification_periodOverdueBody(periodOverdueNotificationDays),
            notificationID: periodOverdueNotificationId,
          );
        } catch (e) {
          debugPrint('Error creating period overdue notification: $e');
        }
      }
    }
    
    final isPeriodOngoing = periods.isNotEmpty && DateUtils.isSameDay(periods.first.endDate, DateTime.now());
    FabState currentState;

    if (!isPeriodOngoing && !widget.isReminderButtonAlwaysVisible) {
      currentState = FabState.logPeriod;
    } else {
      currentState = isReminderSet ? FabState.cancelReminder : FabState.setReminder;
    }
    widget.onFabStateChange(currentState);

    int daysUntilDueForCircle = predictionResult?.daysUntilDue ?? 0; 
		int circleMaxValue = predictionResult?.averageCycleLength ?? 28;
		int circleCurrentValue = daysUntilDueForCircle.clamp(0, circleMaxValue); 

    setState(() {
      _isLoading = false;
      _periodLogEntries = periodDays;
      _periodEntries = periods;
      _predictionResult = predictionResult;
      _selectedView = selectedView;
      _circleCurrentValue = circleCurrentValue;
      _circleMaxValue = circleMaxValue;
    });

    await _watchSyncService.sendCircleData(
      circleMaxValue: _circleMaxValue,
      circleCurrentValue: _circleCurrentValue,
    );
  }

  /// Creates a new log entry.
  Future<void> createNewLog(DateTime selectedDate) async {
    final bool wasLogSuccessful = await PeriodLoggerService.showAndLogPeriod(context, selectedDate);

    if (wasLogSuccessful && mounted) {
      _refreshPeriodLogs();
    }
  }

  /// updates an existing log entry.
  Future<void> _updateExistingLog(PeriodDay updatedLog) async {
    await periodsRepo.updatePeriodLog(updatedLog);

    if (mounted) {
      Navigator.of(context).pop();
    }

    _refreshPeriodLogs();
  }

  /// Deletes a log entry.
	Future<void> _deleteExistingLog(int? id) async {
    if (id == null) return;
		await periodsRepo.deletePeriodLog(id);
		_refreshPeriodLogs();
	}

	@override
	Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

		String predictionText = '';
		if (_isLoading) {
			predictionText = l10n.logsScreen_calculatingPrediction;
		} else if (_predictionResult == null) {
			predictionText = l10n.logScreen_logAtLeastTwoPeriods;
		} else {
			String datePart = DateFormat('dd/MM/yyyy').format(_predictionResult!.estimatedStartDate);
		if (_predictionResult!.daysUntilDue > 0) {
			predictionText = '${l10n.logScreen_nextPeriodEstimate}: $datePart';
		} else if (_predictionResult!.daysUntilDue == 0) {
			predictionText = '${l10n.logScreen_periodDueToday} $datePart';
		} else { // _predictionResult.daysUntilDue is negative, meaning overdue
			predictionText = '${l10n.logScreen_periodOverdueBy(-_predictionResult!.daysUntilDue)}: $datePart';
		}
		}
		return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),
        BasicProgressCircle(
          currentValue: _circleCurrentValue,
          maxValue: _circleMaxValue,
          circleSize: 220,
          strokeWidth: 20,
          progressColor: const Color.fromARGB(255, 255, 118, 118),
          trackColor: const Color.fromARGB(20, 255, 118, 118),
        ),
        const SizedBox(height: 15),
        Text(
          predictionText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 20),
        DynamicHistoryView(
          predictionResult: _predictionResult,
          selectedView: _selectedView,
          periodLogEntries: _periodLogEntries,
          periodEntries: _periodEntries,
          isLoading: _isLoading,
          onLogRequested: createNewLog,
          onLogTapped: _showDetailsBottomSheet,
        ),
      ],
    );
	}
}