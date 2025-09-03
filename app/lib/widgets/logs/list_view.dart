import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:collection/collection.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class PeriodListView extends StatelessWidget {
  final List<PeriodLogEntry> periodLogEntries;
  final List<PeriodEntry> periodEntries;
  final bool isLoading;
  final Function(int) onDelete;

  const PeriodListView({
    super.key,
    required this.periodEntries,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (periodEntries.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            l10n.listViewWidget_noPeriodsLogged,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final items = _buildTimelineItems();

    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is PeriodEntry) {
            return _buildPeriodHeader(item, context);
          } else if (item is PeriodLogEntry) {
            return _buildPeriodLog(item, context);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Object> _buildTimelineItems() {
    final groupedLogs = groupBy(periodLogEntries, (log) => log.periodId ?? -1);
    final List<Object> items = [];
    for (final period in periodEntries) {
      items.add(period);
      final logsForPeriod = groupedLogs[period.id] ?? [];
      items.addAll(logsForPeriod);
    }
    return items;
  }

  Widget _buildPeriodHeader(PeriodEntry period, BuildContext context) {
    final duration = period.endDate.difference(period.startDate).inDays + 1;
    final isOngoing = DateUtils.isSameDay(period.endDate, DateTime.now());

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(period.startDate),
            style: textTheme.titleLarge
          ),
          const SizedBox(height: 4),
          Text(
            '${DateFormat('d MMM').format(period.startDate)} - ${isOngoing ? l10n.ongoing : DateFormat('d MMM').format(period.endDate)} (${l10n.dayCount(duration)})',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  Widget _buildPeriodLog(PeriodLogEntry entry, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n.listViewWidget_confirmDelete),
              content: Text(l10n.listViewWidget_confirmDeleteDescription),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.delete),
                ),
              ],
            );
          },
        );
                      
      },
      onDismissed: (_) {
        if (entry.id != null) onDelete(entry.id!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Text(
                    DateFormat('d').format(entry.date),
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    DateFormat('EEE').format(entry.date).toUpperCase(),
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      entry.flow + 1,
                      (index) => Icon(
                        Icons.water_drop,
                        size: 18,
                        color: colorScheme.primary.withValues(alpha: 0.8)
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (entry.symptoms != null && entry.symptoms!.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: entry.symptoms!.map((symptom) {
                      return Chip(
                        label: Text(symptom),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        backgroundColor: colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}