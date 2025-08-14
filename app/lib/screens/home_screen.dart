import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/widgets/dialogs/log_period_dialog.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/database/period_database.dart'; 
import 'package:menstrudel/widgets/period_list_view.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/services/notifications/period_notifications.dart';
import 'package:menstrudel/widgets/dialogs/tampon_reminder_dialog.dart';
import 'package:menstrudel/services/notifications/tampon_notifications.dart';
import 'package:menstrudel/screens/main_screen.dart';

class HomeScreen extends StatefulWidget {
   final Function(FabState) onFabStateChange;

	const HomeScreen({
    super.key,
    required this.onFabStateChange,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
	List<PeriodLogEntry> _periodLogEntries = [];
  List<PeriodEntry> _periodEntries = [];
	bool _isLoading = false;
	PeriodPredictionResult? _predictionResult;

  Future<void> handleLogPeriod(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext dialogContext) => const SymptomEntryDialog(),
    );

    if (result == null) return;
    if (!context.mounted) return;

    try {
      final DateTime? date = result['date'];
      final List<String>? symptoms = result['symptoms'];
      final int? flow = result['flow'];

      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Date was not provided.')),
        );
        return;
      }

      final newEntry = PeriodLogEntry(
        date: date,
        symptoms: symptoms ?? [],
        flow: flow ?? 0,
      );

      await PeriodDatabase.instance.createPeriodLog(newEntry);
      _refreshPeriodLogs();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save period log. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
  
  Future<void> handleTamponReminder(BuildContext context) async {
    final reminderTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) => const TimeSelectionDialog(),
    );
    if (reminderTime == null) return;
    await TamponNotificationScheduler.schedule(reminderTime: reminderTime);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Reminder set for ${reminderTime.format(context)}')));
      _refreshPeriodLogs();
  }

  Future<void> handleCancelReminder() async {
    try {
      await TamponNotificationScheduler.cancel();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tampon reminder cancelled.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not cancel reminder: $e'), backgroundColor: Colors.red),
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
		setState(() {
			_isLoading = true;
		});

		final periodLogData = await PeriodDatabase.instance.readAllPeriodLogs();
		final periodData = await PeriodDatabase.instance.readAllPeriods();

    final isReminderSet = await TamponNotificationScheduler.isScheduled();
    final isPeriodOngoing = periodData.isNotEmpty && DateUtils.isSameDay(periodData.first.endDate, DateTime.now());

    FabState currentState;

    if (!isPeriodOngoing) {
      currentState = FabState.logPeriod;
    } else {
      currentState = isReminderSet ? FabState.cancelReminder : FabState.setReminder;
    }
    widget.onFabStateChange(currentState);

		setState(() {
			_isLoading = false;
			_periodLogEntries = periodLogData;
			_periodEntries = periodData;
			_predictionResult = PeriodPredictor.estimateNextPeriod(periodLogData, DateTime.now());
			if (_predictionResult != null) {
				final notificationHelper = NotificationHelper();
				notificationHelper.schedulePeriodNotification(
					scheduledTime: _predictionResult!.estimatedDate,
				);
			}
		});
	}

	Future<void> _deletePeriodEntry(int id) async {
		await PeriodDatabase.instance.deletePeriodLog(id);
		_refreshPeriodLogs();
	}

	@override
	Widget build(BuildContext context) {
		int daysUntilDueForCircle = _predictionResult?.daysUntilDue ?? 0; 
		int circleMaxValue = _predictionResult?.averageCycleLength ?? 28;
		int circleCurrentValue = daysUntilDueForCircle.clamp(0, circleMaxValue); 

		String predictionText = '';
		if (_isLoading) {
			predictionText = 'Calculating prediction...';
		} else if (_predictionResult == null) {
			predictionText = 'Log at least two periods to estimate next cycle.';
		} else {
			String datePart = DateFormat('dd/MM/yyyy').format(_predictionResult!.estimatedDate);
		if (_predictionResult!.daysUntilDue > 0) {
			predictionText = 'Next Period Est: $datePart (${_predictionResult!.daysUntilDue} days)';
		} else if (_predictionResult!.daysUntilDue == 0) {
			predictionText = 'Period due TODAY: $datePart';
		} else { // _predictionResult.daysUntilDue is negative, meaning overdue
			predictionText = 'Period overdue by ${-_predictionResult!.daysUntilDue} days: $datePart';
		}
		}
		return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),
        BasicProgressCircle(
          currentValue: circleCurrentValue,
          maxValue: circleMaxValue,
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
        PeriodListView(
          periodLogEnties: _periodLogEntries,
          periodEntries: _periodEntries,
          isLoading: _isLoading,
          onDelete: _deletePeriodEntry
        ),
      ],
    );
	}
}