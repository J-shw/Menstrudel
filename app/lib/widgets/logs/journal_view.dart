import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:provider/provider.dart';

class PeriodJournalView extends StatefulWidget {
final Function(DateTime) onLogRequested;
  final Function(PeriodDay) onLogTapped;

  const PeriodJournalView({
    super.key,
    required this.onLogRequested,
    required this.onLogTapped,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final periodService = context.watch<PeriodService>();
    final predictionResult = periodService.predictionResult;
    final isLoading = periodService.isLoading;
    final logMap = periodService.logMap;
    final earliestLogDate = periodService.earliestLogDate;
    final latestLogDate = periodService.latestLogDate;

    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (earliestLogDate == null) {
      return Expanded(child: Center(child: Text(l10n.journalViewWidget_logYourFirstPeriod)));
    }

    final colorScheme = Theme.of(context).colorScheme;

    final latestLogDateForBoundary = latestLogDate ?? DateTime.now();
    final focusedDateOnly = DateUtils.dateOnly(_focusedDay);
    final calendarBoundary = focusedDateOnly.isAfter(latestLogDateForBoundary) 
        ? focusedDateOnly 
        : latestLogDateForBoundary;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: TableCalendar(
              firstDay: earliestLogDate.subtract(const Duration(days: 365)),
              lastDay: calendarBoundary.add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                disabledTextStyle: TextStyle(
                  color: colorScheme.onSurface.withAlpha(75),
                ),
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              
              enabledDayPredicate: (day) {
                final today = DateUtils.dateOnly(DateTime.now());
                final currentDay = DateUtils.dateOnly(day);
                return !currentDay.isAfter(today);
              },

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                final logForSelectedDay = logMap[DateUtils.dateOnly(selectedDay)];

                if (logForSelectedDay != null) {
                  widget.onLogTapped(logForSelectedDay);
                } else {
                  widget.onLogRequested(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                prioritizedBuilder: (context, day, focusedDay) {
                  final log = logMap[DateUtils.dateOnly(day)];
                  if (log != null) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: log.flow.color,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: colorScheme.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    );
                  }

                  final startDate = predictionResult?.estimatedStartDate;
                  final endDate = predictionResult?.estimatedEndDate;
                  bool isPredictedDay = false;

                  if (startDate != null && endDate != null) {
                    final dayOnly = DateUtils.dateOnly(day);
                    final startOnly = DateUtils.dateOnly(startDate);
                    final endOnly = DateUtils.dateOnly(endDate);

                    isPredictedDay = !dayOnly.isBefore(startOnly) && !dayOnly.isAfter(endOnly);
                  }

                  if (isPredictedDay) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.error.withValues(alpha: 0.4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}