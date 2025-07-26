import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/widgets/log_period.dart';
import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/database/period_database.dart'; 
import 'package:menstrudel/widgets/period_list_view.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:menstrudel/utils/period_predictor.dart';


class HomeScreen extends StatefulWidget {
	const HomeScreen({super.key});
	  @override
  	State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
		final data = await PeriodDatabase.instance.readAllPeriods();
		setState(() {
			_periodEntries = data;
			_isLoading = false;
			_predictionResult = PeriodPredictor.estimateNextPeriod(_periodEntries, DateTime.now()); 
		});
	}

	Future<void> _deletePeriodEntry(int id) async {
		await PeriodDatabase.instance.delete(id);
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
						periodEntries: _periodEntries,
						isLoading: _isLoading,
						onDelete: _deletePeriodEntry
					),
				],
			),

			bottomNavigationBar: BottomAppBar(
				shape: const CircularNotchedRectangle(),
				child: Container(height: 50.0),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () async {
					final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
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
							final newEntry = PeriodEntry(
								date: date,
								symptom: symptom,
								flow: flow,
							);

							await PeriodDatabase.instance.create(newEntry);
							_refreshPeriodLogs();

							ScaffoldMessenger.of(context).showSnackBar(
								SnackBar(
									content: Text('Logged: ${symptom ?? "N/A"} (Flow: $flow) on ${DateFormat('dd/MM/yyyy').format(date)}'),
									duration: const Duration(seconds: 3),
								),
							);
						}
					}
				},
				tooltip: 'Log period',
				child: const Icon(Icons.add),
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
		);
	}
}