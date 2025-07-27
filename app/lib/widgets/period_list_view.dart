import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs.dart';

class PeriodListView extends StatelessWidget {
	final List<PeriodEntry> periodEntries;
	final bool isLoading;
	final Function(int) onDelete;

	const PeriodListView({
		super.key,
		required this.periodEntries,
		required this.isLoading,
		required this.onDelete,
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

						final int numberOfDrops = entry.flow + 1; 

						final List<Widget> flowIcons = List.generate(
							numberOfDrops,
							(index) => Icon(
								Icons.water_drop,
								size: 16,
								color: Theme.of(context).colorScheme.primary,
							),
						);

						return Dismissible(
							key: ValueKey(entry.id),
							direction: DismissDirection.endToStart,
							background: Container(
								color: Colors.red,
								alignment: Alignment.centerRight,
								padding: const EdgeInsets.symmetric(horizontal: 20),
								child: const Icon(Icons.delete, color: Colors.white),
							),
							confirmDismiss: (direction) async {
								return await showDialog(
									context: context,
									builder: (BuildContext context) {
										return AlertDialog(
											title: const Text("Confirm Delete"),
											content: const Text("Are you sure you want to delete this entry?"),
											actions: <Widget>[
												TextButton(
													onPressed: () => Navigator.of(context).pop(false), // Don't dismiss
													child: const Text("Cancel"),
												),
												ElevatedButton(
													onPressed: () => Navigator.of(context).pop(true), // Confirm dismissal
													child: const Text("Delete"),
												),
											],
										);
									},
								);
							},
							onDismissed: (direction) {
								if (entry.id != null) {
									onDelete(entry.id!);
								}
							},
							child: Card(
								margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
								child: ListTile(
									title: Text(DateFormat('dd/MM/yyyy').format(entry.date), style: TextStyle(fontWeight: FontWeight.bold)),
									subtitle: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											'Symptom: $displayedSymptom',
											style: TextStyle(
												fontSize: 14,
												color: Theme.of(context).colorScheme.onSurfaceVariant,
											),
										),
										const SizedBox(height: 4),

										Row(
											children: [
											Text(
												'Flow: ',
												style: TextStyle(
													fontSize: 14,
													color: Theme.of(context).colorScheme.onSurfaceVariant,
												),
											),
											...flowIcons,
											],
										),
										],
									),
								),
							),
						);
					},
				),
			);
		}
	}
}