import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/widgets/log_period.dart';

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
				// Show the dialog and await the result
				final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
					context: context,
					builder: (BuildContext dialogContext) { // Use dialogContext to avoid conflicts
						return const SymptomEntryDialog(); // Return your dialog widget
					},
				);
				if (result != null) {
					// Handle the data returned from the dialog
					final DateTime? date = result['date'];
					final String? symptom = result['symptom'];
					
					if (date != null && symptom != null) {
						// For demonstration, print the results and show a SnackBar
						print('Symptom Logged: $symptom on ${DateFormat('dd/MM/yyyy').format(date)}');
						ScaffoldMessenger.of(context).showSnackBar(
							SnackBar(
							content: Text('Symptom "$symptom" added for ${DateFormat('dd/MM/yyyy').format(date)}'),
							duration: const Duration(seconds: 3),
							),
						);
					}
				} else {
					print('Dialog was cancelled or no symptom selected.');
				}
			},
			tooltip: 'Log symptoms',
			child: const Icon(Icons.add),
		),
		floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
		);
	}
}