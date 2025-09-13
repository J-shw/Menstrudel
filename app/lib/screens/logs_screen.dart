import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';

import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/dialogs/tampon_reminder_dialog.dart';
import 'package:menstrudel/screens/main_screen.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/period_logger_service.dart';
import 'package:menstrudel/widgets/logs/dynamic_history_view.dart';
import 'package:menstrudel/services/wear_sync_service.dart';

import 'package:menstrudel/l10n/app_localizations.dart';


class LogsScreen extends StatefulWidget {
   final Function(FabState) onFabStateChange;

	const LogsScreen({
    super.key,
    required this.onFabStateChange,
  });

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  final periodsRepo = PeriodsRepository();
  final SettingsService _settingsService = SettingsService();

  final _watchSyncService = WatchSyncService();

	List<PeriodDay> _periodLogEntries = [];
  List<Period> _periodEntries = [];
	bool _isLoading = true;
	PeriodPredictionResult? _predictionResult;
  PeriodHistoryView _selectedView = PeriodHistoryView.journal;
  int _circleCurrentValue = 0;
  int _circleMaxValue = 28;

  Future<void> handleLogPeriod(DateTime selectedDate) async {
    final bool wasLogSuccessful = await PeriodLoggerService.showAndLogPeriod(context, selectedDate);

    if (wasLogSuccessful && mounted) {
      _refreshPeriodLogs();
    }
  }
  
  Future<void> handleTamponReminder(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final reminderTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) => const TimeSelectionDialog(),
    );
    if (reminderTime == null) return;
    await NotificationService.scheduleTamponReminder(
      reminderTime: reminderTime,
      title: l10n.notification_tamponReminderTitle,
      body: l10n.notification_tamponReminderBody,
      );
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${l10n.logScreen_tamponReminderSetFor} ${reminderTime.format(context)}')));
        _refreshPeriodLogs();
    }
  }

  Future<void> handleCancelReminder() async {
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
      _refreshPeriodLogs();
    }
  }

	@override
	void initState() {
		super.initState();
		_refreshPeriodLogs();
	}

	Future<void> _refreshPeriodLogs() async {
    final periodDays = await periodsRepo.readAllPeriodLogs();
    final periods = await periodsRepo.readAllPeriods();
    final isReminderSet = await NotificationService.isTamponReminderScheduled();
    final predictionResult = PeriodPredictor.estimateNextPeriod(periods, DateTime.now());
    final selectedView = await _settingsService.getHistoryView();

    if (predictionResult != null) {
      final settingsService = SettingsService();
      final notificationsEnabled = await settingsService.areNotificationsEnabled();
      final notificationDays = await settingsService.getNotificationDays();
      final notificationTime = await settingsService.getNotificationTime();

      if (mounted){
        final l10n = AppLocalizations.of(context)!;
      
        await NotificationService.schedulePeriodNotification(
          scheduledTime: predictionResult.estimatedStartDate,
          areEnabled: notificationsEnabled,
          daysBefore: notificationDays,
          notificationTime: notificationTime,
          title: l10n.notification_periodTitle,
          body: l10n.notification_periodBody(notificationDays),
        );
      }
    }
    
    final isPeriodOngoing = periods.isNotEmpty && DateUtils.isSameDay(periods.first.endDate, DateTime.now());
    FabState currentState;
    if (!isPeriodOngoing) {
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

  void _handleSaveLog(PeriodDay updatedLog) {
    periodsRepo.updatePeriodLog(updatedLog);
    Navigator.of(context).pop();
    _refreshPeriodLogs();
  }

	Future<void> _deletePeriodEntry(int id) async {
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
          onDelete: _deletePeriodEntry,
          onSave: _handleSaveLog,
          onLogRequested: handleLogPeriod,
        ),
      ],
    );
	}
}