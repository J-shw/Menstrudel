import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/models/period_prediction_result.dart';
import 'package:collection/collection.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodJournalView extends StatefulWidget {
  final List<PeriodLogEntry> periodLogEntries;
  final PeriodPredictionResult? predictionResult;
  final bool isLoading;
  final Function(int) onDelete;

  const PeriodJournalView({
    super.key,
    required this.periodLogEntries,
    required this.predictionResult,
    required this.isLoading,
    required this.onDelete,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  late List<PeriodLogEntry> _currentLogEntries;
  PeriodLogEntry? _selectedLog;
  Map<DateTime, PeriodLogEntry> _logMap = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _processEntries();
    _selectedDay = null;
    _selectedLog = null;
  }

  @override
  void didUpdateWidget(covariant PeriodJournalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodLogEntries != oldWidget.periodLogEntries) {
      _processEntries();
      if (_selectedDay != null) {
        _selectedLog = _logMap[DateUtils.dateOnly(_selectedDay!)];
      }
    }
  }

  void _processEntries() {
    _currentLogEntries = List.from(widget.periodLogEntries);
    _currentLogEntries.sort((a, b) => a.date.compareTo(b.date));
    _logMap = {
      for (var log in _currentLogEntries) DateUtils.dateOnly(log.date): log
    };
  }

  void _handleDelete(PeriodLogEntry entryToDelete) {
    final index =
        _currentLogEntries.indexWhere((e) => e.id == entryToDelete.id);
    if (index == -1) return;
    setState(() {
      _currentLogEntries.removeAt(index);
      _processEntries();
      _selectedLog = null;
      _selectedDay = null;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: const Text('Journal updated.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _currentLogEntries.insert(index, entryToDelete);
                  _processEntries();
                  _selectedDay = entryToDelete.date;
                  _selectedLog = entryToDelete;
                });
              }),
        ))
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action && entryToDelete.id != null) {
        widget.onDelete(entryToDelete.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (_currentLogEntries.isEmpty) {
      return const Expanded(child: Center(child: Text('Log your first period.')));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          _DetailsPanel(
            log: _selectedLog,
            onDelete: () {
              if (_selectedLog != null) _handleDelete(_selectedLog!);
            },
          ),
          Expanded(
            child: TableCalendar(
              firstDay:
                  _currentLogEntries.first.date.subtract(const Duration(days: 365)),
              lastDay: _currentLogEntries.last.date.add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              eventLoader: (day) {
                final log = _logMap[DateUtils.dateOnly(day)];
                return log != null ? [log] : [];
              },
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                final logForSelectedDay = _logMap[DateUtils.dateOnly(selectedDay)];
                if (logForSelectedDay != null) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedLog = logForSelectedDay;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  return const SizedBox();
                },
                prioritizedBuilder: (context, day, focusedDay) {
                  final log = _logMap[DateUtils.dateOnly(day)];
                  final isSelected = isSameDay(_selectedDay, day);
                  final isPredictedDay = isSameDay(day, widget.predictionResult?.estimatedDate);

                  if (log != null) {
                    final flowOpacity = 0.3 + (log.flow * 0.33);
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: flowOpacity),
                        border: isSelected
                            ? Border.all(color: colorScheme.primary, width: 2.5)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                        color: colorScheme.error.withValues(alpha: 0.7),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: colorScheme.onError,
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

class _DetailsPanel extends StatelessWidget {
  final PeriodLogEntry? log;
  final VoidCallback onDelete;

  const _DetailsPanel({required this.log, required this.onDelete});

 @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: log == null
              ? SizedBox(
                  height: 48,
                  child: Center(
                    child: Text(
                      "Select a day from your journal",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM d, yyyy').format(log!.date),
                          style: textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: onDelete,
                          borderRadius: BorderRadius.circular(24),
                          child: Icon(Icons.delete_outline,
                              size: 20, color: colorScheme.error),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(
                          3,
                          (index) => Icon(
                            index < log!.flow + 1
                                ? Icons.water_drop
                                : Icons.water_drop_outlined,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (log!.symptoms != null && log!.symptoms!.isNotEmpty)
                          Expanded(
                            child: SizedBox(
                              height: 25,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: log!.symptoms!
                                    .map((s) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: Chip(
                                            label: Text(s),
                                            visualDensity: VisualDensity.compact,
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            labelStyle: textTheme.labelSmall,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
        );
  }
}