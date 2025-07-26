import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs.dart';

final List<String> flowLabels = ["Low", "Medium", "High"];

class PeriodListView extends StatelessWidget {
	final List<PeriodEntry> periodEntries;
	final bool isLoading;

	const PeriodListView({
		super.key,
		required this.periodEntries,
		required this.isLoading,
	});

	@override
	Widget build(BuildContext context) {
		if (isLoading) {
			return const Center(child: CircularProgressIndicator());
			} else if (periodEntries.isEmpty) {
			return const Center(
				child: Text(
				'No periods logged yet.\nTap the + button to add one.',
				textAlign: TextAlign.center,
				style: TextStyle(fontSize: 16, color: Colors.grey),
				),
			);
			} else {
			return Expanded(
				child: ListView.builder(
				itemCount: periodEntries.length,
				itemBuilder: (context, index) {
					final entry = periodEntries[index];
					final String displayedSymptom = entry.symptom?.isNotEmpty == true ? entry.symptom! : 'No specific symptom';
					return Card(
					margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
					child: ListTile(
						title: Text(DateFormat('dd/MM/yyyy').format(entry.date), style: TextStyle(fontWeight: FontWeight.bold)),
						subtitle: Text(
							'Symptons: $displayedSymptom | Flow: ${flowLabels[entry.flow]}',
						),
					),
					);
				},
				),
			);
		}
	}
}