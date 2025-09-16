import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:collection/collection.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/flow_enum.dart';
import 'package:menstrudel/models/period_logs/symptom_enum.dart';

class PeriodListView extends StatelessWidget {
  final List<PeriodDay> periodLogEntries;
  final List<Period> periodEntries;
  final bool isLoading;
  final Function(PeriodDay) onLogTapped;

  const PeriodListView({
    super.key,
    required this.periodEntries,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onLogTapped,
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
          if (item is Period) {
            return _buildPeriodHeader(item, context);
          } else if (item is PeriodDay) {
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

  Widget _buildPeriodHeader(Period period, BuildContext context) {
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

  Widget _buildPeriodLog(PeriodDay entry, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final symptomMap = {for (var s in Symptom.values) s.name: s};
    final symptoms = entry.symptoms
            ?.map((s) => symptomMap[s])
            .whereType<Symptom>()
            .toList() ?? [];

    return InkWell(
      onTap: () => onLogTapped(entry),
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
                      entry.flow.intValue,
                      (index) => Icon(
                        Icons.water_drop,
                        size: 18,
                        color: colorScheme.primary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (symptoms.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: symptoms.map((symptom) {
                      return Chip(
                        label: Text(symptom.getDisplayName(l10n)),
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