import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/widgets/log_period.dart';
import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/models/period.dart';
import 'package:menstrudel/database/period_database.dart'; 
import 'package:menstrudel/widgets/period_list_view.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/period_predictor.dart';
import 'package:menstrudel/widgets/navigation_bar.dart';
import 'package:menstrudel/services/period_notifications.dart';
import 'package:menstrudel/widgets/tampon_reminder_dialog.dart';


class HomeScreen extends StatefulWidget {
	const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	List<PeriodLogEntry> _periodLogEntries = [];
  List<PeriodEntry> _periodEntries = [];
	bool _isLoading = false;
	PeriodPredictionResult? _predictionResult;

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

    final bool isPeriodOngoing = _periodEntries.isNotEmpty && DateUtils.isSameDay(_periodEntries.first.endDate, DateTime.now());

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
		return Scaffold(
			body: Column(
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
			),
			bottomNavigationBar: MainBottomNavigationBar(isHomeScreenActive: true,),
			floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: isPeriodOngoing,
          child: FloatingActionButton(
            onPressed: () async {
              final TimeOfDay? reminderTime = await showDialog<TimeOfDay>(
                context: context,
                builder: (BuildContext context) {
                  return const TimeSelectionDialog();
                },
              );

              if (reminderTime != null) {
                print('Reminder time received: ${reminderTime.format(context)}');
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Reminder set for ${reminderTime.format(context)}'),
                    ),
                  );
              }
            },
            tooltip: 'Tampon reminder',
            heroTag: null,
            child: const Icon(Icons.add_alarm),
          ),
        ),

        const SizedBox(height: 16),

        FloatingActionButton(
          onPressed: () async {
            final Map<String, dynamic>? result =
                await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (BuildContext dialogContext) {
                return const SymptomEntryDialog();
              },
            );
            if (result != null) {
              final DateTime? date = result['date'];
              final String? symptom = result['symptom'];
              final int flow = result['flow'];

              if (date != null) {
                final newEntry = PeriodLogEntry(
                  date: date,
                  symptom: symptom,
                  flow: flow,
                );

                await PeriodDatabase.instance.createPeriodLog(newEntry);
                _refreshPeriodLogs();
              }
            }
          },
          tooltip: 'Log period',
          heroTag: null,
          child: const Icon(Icons.add),
        ),
      ],
    ),
			floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
		);
	}
}