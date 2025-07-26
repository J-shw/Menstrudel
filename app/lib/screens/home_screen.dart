import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/widgets/log_period.dart';
import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/database/period_database.dart'; 


class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

@override
Widget build(BuildContext context) {
	return Scaffold(
		body: Column(
			mainAxisSize: MainAxisSize.max,
			mainAxisAlignment: MainAxisAlignment.start,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				const SizedBox(height: 100),
				BasicProgressCircle(
					currentValue: 7,
					maxValue: 30,
					circleSize: 220,
					strokeWidth: 20,
					progressColor: const Color.fromARGB(255, 255, 118, 118),
					trackColor: const Color.fromARGB(20, 255, 118, 118),
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