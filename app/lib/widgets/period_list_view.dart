import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs.dart';
import 'package:menstrudel/models/period.dart';
import 'package:collection/collection.dart';

class PeriodListView extends StatelessWidget {
	final List<PeriodLogEntry> periodLogEnties;
	final List<PeriodEntry> periodEntries;
	final bool isLoading;
	final Function(int) onDelete;

	const PeriodListView({
		super.key,
		required this.periodEntries,
		required this.periodLogEnties,
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
			final Map<int, List<PeriodLogEntry>> groupedLogs = groupBy(periodLogEnties, (log) => log.periodId ?? -1);
			return Expanded(
        child: ListView.builder(
          itemCount: periodEntries.length,
          itemBuilder: (context, periodIndex) {
            final period = periodEntries[periodIndex];
            final logsForPeriod = groupedLogs[period.id] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                  child: Text(
                    '${DateFormat('dd/MM/yy').format(period.startDate)} - ${period.endDate != null ? DateFormat('dd/MM/yy').format(period.endDate!) : 'Ongoing'}', // This won't work yet but might be better
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                if (logsForPeriod.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text(
                      'No logs for this period.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logsForPeriod.length,
                  itemBuilder: (context, logIndex) {
                    final entry = logsForPeriod[logIndex];
                    final String displayedSymptom =
                        entry.symptom?.isNotEmpty == true
                            ? entry.symptom!
                            : 'No specific symptom';

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
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
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
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
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
                          title: Text(
                                DateFormat('dd/MM/yyyy').format(entry.date),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
							  Text(
									'Symptom: $displayedSymptom',
									style: TextStyle(fontWeight: FontWeight.bold),
								),
                              const SizedBox(height: 4),
                              Row(
                                children: [
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
                const Divider(),
              ],
            );
          },
        ),
      );
		}
	}
}