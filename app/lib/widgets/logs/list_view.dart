import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:collection/collection.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
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

    if (periodEntries.isEmpty && periodLogEntries.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            l10n.listViewWidget_noPeriodsLogged,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
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
          if (item is DateTime) {
            return _buildMonthHeader(item, context);
          } else if (item is Period) {
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

    final List<Object> timelineEvents = [
      ...periodEntries,
      ...(groupedLogs[-1] ?? []),
    ];

    final groupedByMonth = groupBy<Object, DateTime>(timelineEvents, (event) {
      final date = event is Period ? event.startDate : (event as PeriodDay).date;
      return DateTime(date.year, date.month);
    });

    final sortedMonths = groupedByMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final List<Object> items = [];
    for (final month in sortedMonths) {
      items.add(month);

      final eventsInMonth = groupedByMonth[month]!;
      eventsInMonth.sort((a, b) {
        final dateA = a is Period ? a.startDate : (a as PeriodDay).date;
        final dateB = b is Period ? b.startDate : (b as PeriodDay).date;
        return dateB.compareTo(dateA);
      });

      for (final event in eventsInMonth) {
        if (event is Period) {
          items.add(event);
          final logsForPeriod = (groupedLogs[event.id] ?? [])
            ..sort((a, b) => a.date.compareTo(b.date));
          items.addAll(logsForPeriod);
        } else if (event is PeriodDay) {
          items.add(event);
        }
      }
    }
    return items;
  }
  
  Widget _buildMonthHeader(DateTime month, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        DateFormat('MMMM yyyy').format(month),
        style: textTheme.titleLarge,
      ),
    );
  }

  Widget _buildPeriodHeader(Period period, BuildContext context) {
    final duration = period.endDate.difference(period.startDate).inDays + 1;
    final isOngoing = DateUtils.isSameDay(period.endDate, DateTime.now());
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateFormat('d MMM').format(period.startDate)} - ${isOngoing ? l10n.ongoing : DateFormat('d MMM').format(period.endDate)} (${l10n.dayCount(duration)})',
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
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
    final symptoms =
        entry.symptoms?.map((s) => symptomMap[s]).whereType<Symptom>().toList() ?? [];
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
                  Text(DateFormat('d').format(entry.date), style: textTheme.titleMedium),
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
                  if (entry.flow.intValue > 0)
                    Row(
                      children: List.generate(
                        entry.flow.intValue,
                        (index) => Icon(
                          Icons.water_drop,
                          size: 18,
                          color: colorScheme.primary.withAlpha(200),
                        ),
                      ),
                    ),
                  if (entry.flow.intValue > 0 && symptoms.isNotEmpty) const SizedBox(height: 6),
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