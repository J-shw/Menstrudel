import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:collection/collection.dart';

class PeriodJournalView extends StatefulWidget {
  final List<PeriodLogEntry> periodLogEntries;
  final bool isLoading;
  final Function(int) onDelete;

  const PeriodJournalView({
    super.key,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onDelete,
  });

  @override
  State<PeriodJournalView> createState() => _PeriodJournalViewState();
}

class _PeriodJournalViewState extends State<PeriodJournalView> {
  late List<PeriodLogEntry> _currentLogEntries;
  PeriodLogEntry? _selectedLog;
  List<List<DateTime>> _weeks = [];
  Map<DateTime, PeriodLogEntry> _logMap = {};

  @override
  void initState() {
    super.initState();
    _processEntries();
    _selectedLog = _currentLogEntries.isNotEmpty ? _currentLogEntries.last : null;
  }

  @override
  void didUpdateWidget(covariant PeriodJournalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodLogEntries != oldWidget.periodLogEntries) {
      _processEntries();
      _selectedLog = _currentLogEntries.firstWhereOrNull(
        (e) => e.id == _selectedLog?.id,
      );
    }
  }

  void _processEntries() {
    _currentLogEntries = List.from(widget.periodLogEntries);
    _currentLogEntries.sort((a, b) => a.date.compareTo(b.date));

    _logMap = {for (var log in _currentLogEntries) DateUtils.dateOnly(log.date): log};

    if (_currentLogEntries.isEmpty) {
      _weeks = [];
      return;
    }

    final firstDay = _currentLogEntries.first.date;
    final lastDay = _currentLogEntries.last.date;
    
    var currentDay = firstDay.subtract(Duration(days: firstDay.weekday % 7));
    
    final allWeeks = <List<DateTime>>[];
    while(currentDay.isBefore(lastDay) || DateUtils.isSameDay(currentDay, lastDay)) {
        final week = List.generate(7, (i) => currentDay.add(Duration(days: i)));
        allWeeks.add(week);
        currentDay = currentDay.add(const Duration(days: 7));
    }
    _weeks = allWeeks;
  }

  void _handleDelete(PeriodLogEntry entryToDelete) {
    final index = _currentLogEntries.indexWhere((e) => e.id == entryToDelete.id);
    if (index == -1) return;
    setState(() {
      _currentLogEntries.removeAt(index);
      _processEntries();
      _selectedLog = index > 0 ? _currentLogEntries[index - 1] : (_currentLogEntries.isNotEmpty ? _currentLogEntries.first : null);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Journal updated.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'Undo', onPressed: () {
            setState(() {
              _currentLogEntries.insert(index, entryToDelete);
              _processEntries();
              _selectedLog = entryToDelete;
            });
          }),
        )).closed.then((reason) {
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
    
    return Expanded(
      child: Column(
        children: [
          _DetailsPanel(
            log: _selectedLog,
            onDelete: () {
              if (_selectedLog != null) _handleDelete(_selectedLog!);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _weeks.length,
              itemBuilder: (context, index) {
                final week = _weeks[index];
                bool isFirstWeekOfMonth = true;
                if(index > 0) {
                    final prevWeek = _weeks[index-1];
                    isFirstWeekOfMonth = week.first.month != prevWeek.first.month;
                }
                
                return _WeekRow(
                  week: week,
                  logMap: _logMap,
                  selectedLog: _selectedLog,
                  showMonthLabel: isFirstWeekOfMonth || index == 0,
                  onDaySelected: (log) {
                    setState(() {
                      _selectedLog = log;
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  final List<DateTime> week;
  final Map<DateTime, PeriodLogEntry> logMap;
  final PeriodLogEntry? selectedLog;
  final bool showMonthLabel;
  final Function(PeriodLogEntry) onDaySelected;

  const _WeekRow({
    required this.week,
    required this.logMap,
    this.selectedLog,
    required this.showMonthLabel,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMonthLabel)
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0),
            child: Text(
              DateFormat('MMMM yyyy').format(week.first),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((day) {
              final log = logMap[DateUtils.dateOnly(day)];
              return _DayCell(
                date: day,
                log: log,
                isSelected: selectedLog != null && log != null && selectedLog!.id == log!.id,
                onTap: () {
                  if (log != null) onDaySelected(log);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final PeriodLogEntry? log;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    this.log,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isPeriodDay = log != null;
    final double flowOpacity = isPeriodDay ? 0.3 + (log!.flow * 0.15) : 0.0;

    return GestureDetector(
      onTap: isPeriodDay ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPeriodDay ? colorScheme.primary.withValues(alpha: flowOpacity) : Colors.transparent,
          border: isSelected 
              ? Border.all(color: colorScheme.primary, width: 2.5)
              : null,
        ),
        child: Center(
          child: Text(
            DateFormat('d').format(date),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isPeriodDay ? colorScheme.onPrimary.withValues(alpha: 0.9) : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
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

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: Container(
          key: ValueKey(log?.id),
          height: 150,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: log == null
              ? Center(child: Text("Select a day from the journal", style: textTheme.titleMedium))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM d').format(log!.date),
                          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: colorScheme.error),
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                    Text("Flow", style: textTheme.bodySmall),
                    Row(
                      children: List.generate(3, (index) => Icon(
                        index < log!.flow + 1 ? Icons.water_drop : Icons.water_drop_outlined,
                        color: colorScheme.primary,
                      )),
                    ),
                    if (log!.symptoms != null && log!.symptoms!.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: log!.symptoms!.map((s) => Chip(label: Text(s))).toList(),
                          ),
                        ),
                      )
                  ],
                ),
        ),
      );
    }
  }