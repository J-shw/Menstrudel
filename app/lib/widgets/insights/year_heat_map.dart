import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/flow_enum.dart'; 

class YearHeatmapWidget extends StatelessWidget {
  final List<PeriodDay> logs;
  const YearHeatmapWidget({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final Map<DateTime, PeriodDay> periodDayEvents = {
      for (var log in logs)
        DateTime.utc(log.date.year, log.date.month, log.date.day): log
    };

    return Card(
      elevation: 0,
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
                defaultBuilder: (context, date, focusedDay) {
                  final dayKey = DateTime.utc(date.year, date.month, date.day);
                  final logForDay = periodDayEvents[dayKey];

                  if (logForDay != null && logForDay.flow != FlowRate.none) {
                    return Container(
                      decoration: BoxDecoration(
                        color: logForDay.flow.color,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
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