import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:table_calendar/table_calendar.dart';

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

  String _getFlowLabel(int flow) {
    switch (flow) {
      case 0:
        return 'Light';
      case 1:
        return 'Medium';
      case 2:
        return 'Heavy';
      default:
        return '';
    }
  }

  void _showDetailsBottomSheet(PeriodLogEntry log) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d').format(log.date),
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 24, color: colorScheme.error),
                    onPressed: () => _handleDelete(log),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.opacity,
                      color: colorScheme.onSurfaceVariant, size: 20),
                  const SizedBox(width: 12),
                  Text('Flow: ', style: textTheme.bodyLarge),
                  Text(_getFlowLabel(log.flow),
                      style: textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ...List.generate(
                    3,
                    (index) => Icon(
                      index < log.flow + 1
                          ? Icons.water_drop
                          : Icons.water_drop_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              if (log.symptoms != null && log.symptoms!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.bubble_chart_outlined,
                        color: colorScheme.onSurfaceVariant, size: 20),
                    const SizedBox(width: 12),
                    Text('Symptoms:', style: textTheme.bodyLarge),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: log.symptoms!
                          .map((s) => Chip(label: Text(s)))
                          .toList(),
                    ),
                  ),
                ),
              ]
            ],
          ),
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
    if (widget.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (widget.periodLogEntries.isEmpty) {
      return const Expanded(child: Center(child: Text('Log your first period.')));
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