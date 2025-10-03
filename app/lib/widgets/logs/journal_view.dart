import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';

class PeriodJournalView extends StatefulWidget {
  final List<PeriodDay> periodLogEntries;
  final bool isLoading;
  final Function(PeriodDay) onLogTapped;
  final PeriodPredictionResult? predictionResult;
  final Function(DateTime) onLogRequested;

  const PeriodJournalView({
    super.key,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onLogTapped,
    this.predictionResult,
    required this.onLogRequested,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, PeriodDay> _logMap = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _processEntries();
  }

  @override
  void didUpdateWidget(covariant PeriodJournalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodLogEntries != oldWidget.periodLogEntries) {
      _processEntries();

      if (widget.periodLogEntries.isNotEmpty) {
        final earliestLogDate = widget.periodLogEntries.reduce((a, b) => a.date.isBefore(b.date) ? a : b).date;
        final latestLogDate = widget.periodLogEntries.reduce((a, b) => a.date.isAfter(b.date) ? a : b).date;
        
        final focusedDateOnly = DateUtils.dateOnly(_focusedDay);

        if (focusedDateOnly.isAfter(latestLogDate) || focusedDateOnly.isBefore(earliestLogDate)) {
          setState(() {
            _focusedDay = latestLogDate;
          });
        }
      }
    }
  }

  void _processEntries() {
    _logMap = {
      for (var log in widget.periodLogEntries) DateUtils.dateOnly(log.date): log
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (widget.periodLogEntries.isEmpty) {
      return Expanded(child: Center(child: Text(l10n.journalViewWidget_logYourFirstPeriod)));
    }

    final colorScheme = Theme.of(context).colorScheme;

    final earliestLogDate = widget.periodLogEntries.reduce((a, b) => a.date.isBefore(b.date) ? a : b).date;
    final latestLogDate = widget.periodLogEntries.reduce((a, b) => a.date.isAfter(b.date) ? a : b).date;

    final focusedDateOnly = DateUtils.dateOnly(_focusedDay);

    final calendarBoundary = focusedDateOnly.isAfter(latestLogDate) ? focusedDateOnly : latestLogDate;


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
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                final logForSelectedDay =
                    _logMap[DateUtils.dateOnly(selectedDay)];

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
                  final log = _logMap[DateUtils.dateOnly(day)];
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

                  final startDate = widget.predictionResult?.estimatedStartDate;
                  final endDate = widget.predictionResult?.estimatedEndDate;
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