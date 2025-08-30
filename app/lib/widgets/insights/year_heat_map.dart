import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class YearHeatmapWidget extends StatelessWidget {
  final List<PeriodLogEntry> logs;
  const YearHeatmapWidget({super.key, required this.logs});
  
  Color _getFlowColor(int flow) {
    if (flow <= 1) return Colors.pink.shade100;
    if (flow == 2) return Colors.pink.shade300;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final Map<DateTime, int> flowEvents = {
      for (var log in logs) DateTime.utc(log.date.year, log.date.month, log.date.day): log.flow
    };

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.yearHeatMapWidget_yearlyOverview, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.utc(DateTime.now().year, 1, 1),
              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
              focusedDay: DateTime.now(),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: textTheme.bodyLarge!,
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final dayKey = DateTime.utc(date.year, date.month, date.day);

                  if (flowEvents.containsKey(dayKey)) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _getFlowColor(flowEvents[dayKey]!),
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.all(5.0),
                    );
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}