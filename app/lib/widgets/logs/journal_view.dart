import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/sheets/period_details_bottom_sheet.dart';

class PeriodJournalView extends StatefulWidget {
  final List<PeriodLogEntry> periodLogEntries;
  final bool isLoading;
  final Function(int) onDelete;
  final PeriodPredictionResult? predictionResult;
  final Function(DateTime) onLogRequested;

  const PeriodJournalView({
    super.key,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onDelete,
    this.predictionResult,
    required this.onLogRequested,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, PeriodLogEntry> _logMap = {};

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
    }
  }

  void _processEntries() {
    _logMap = {
      for (var log in widget.periodLogEntries) DateUtils.dateOnly(log.date): log
    };
  }

  void _handleDelete(PeriodLogEntry entryToDelete) {
    Navigator.of(context).pop();
    if (entryToDelete.id != null) {
      widget.onDelete(entryToDelete.id!);
    }
  }

  void _showDetailsBottomSheet(PeriodLogEntry log) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return PeriodDetailsBottomSheet(
          log: log,
          onDelete: () => _handleDelete(log),
        );
      },
    ).then((_) {
      setState(() {
        _selectedDay = null;
      });
    });
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

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: TableCalendar(
              firstDay: widget.periodLogEntries.first.date
                  .subtract(const Duration(days: 365)),
              lastDay: widget.periodLogEntries.last.date
                  .add(const Duration(days: 365)),
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
                  _showDetailsBottomSheet(logForSelectedDay);
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
                  final isPredictedDay =
                      isSameDay(day, widget.predictionResult?.estimatedDate);

                  if (log != null) {
                    final flowOpacity = 0.3 + (log.flow * 0.33);
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: flowOpacity),
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