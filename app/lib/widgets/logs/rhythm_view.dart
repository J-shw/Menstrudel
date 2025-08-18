import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:collection/collection.dart';

class RhythmView extends StatefulWidget {
  final List<PeriodLogEntry> periodLogEntries;
  final bool isLoading;
  final Function(int) onDelete;

  const RhythmView({
    super.key,
    required this.periodLogEntries,
    required this.isLoading,
    required this.onDelete,
  });

  @override
  State<RhythmView> createState() => _RhythmViewState();
}

class _RhythmViewState extends State<RhythmView> {
  late List<PeriodLogEntry> _currentLogEntries;
  PeriodLogEntry? _selectedLog;

  @override
  void initState() {
    super.initState();
    _updateAndSortLogs();
    _selectedLog = _currentLogEntries.isNotEmpty ? _currentLogEntries.last : null;
  }

  @override
  void didUpdateWidget(covariant RhythmView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodLogEntries != oldWidget.periodLogEntries) {
      _updateAndSortLogs();
      _selectedLog = _currentLogEntries.firstWhereOrNull(
        (e) => e.id == _selectedLog?.id,
      );
    }
  }

  void _updateAndSortLogs() {
    _currentLogEntries = List.from(widget.periodLogEntries);
    _currentLogEntries.sort((a, b) => a.date.compareTo(b.date));
  }
  
  void _handleDelete(PeriodLogEntry entryToDelete) {
    final index = _currentLogEntries.indexWhere((e) => e.id == entryToDelete.id);
    if (index == -1) return;

    setState(() {
      _currentLogEntries.removeAt(index);
      _selectedLog = index > 0 ? _currentLogEntries[index - 1] : (_currentLogEntries.isNotEmpty ? _currentLogEntries.first : null);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: const Text('Rhythm updated.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'Undo', onPressed: () {
            setState(() {
              _currentLogEntries.insert(index, entryToDelete);
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
    
    return Expanded(
      child: Column(
        children: [
          _DetailsPanel(
            log: _selectedLog,
            onDelete: () {
              if (_selectedLog != null) _handleDelete(_selectedLog!);
            },
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            height: 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: GestureDetector(
                onTapDown: (details) {
                  final dx = details.localPosition.dx;
                  final index = (dx / 50.0).round();
                  if (index >= 0 && index < _currentLogEntries.length) {
                    setState(() => _selectedLog = _currentLogEntries[index]);
                  }
                },
                child: CustomPaint(
                  size: Size(
                      _currentLogEntries.length * 50.0, 150),
                  painter: _CycleRhythmPainter(
                    logEntries: _currentLogEntries,
                    selectedLog: _selectedLog,
                    primaryColor: Theme.of(context).colorScheme.primary,
                    onSurfaceColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(log?.id),
        height: 150,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: log == null
            ? const Center(child: Text("Select a day"))
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
                  const SizedBox(height: 8),
                  Text("Flow", style: textTheme.bodySmall),
                  Row(
                    children: List.generate(5, (index) => Icon(
                      index < log!.flow + 1 ? Icons.water_drop : Icons.water_drop_outlined,
                      color: colorScheme.primary,
                    )),
                  ),
                  const SizedBox(height: 8),
                  if (log!.symptoms != null && log!.symptoms!.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: log!.symptoms!.map((s) => Chip(label: Text(s))).toList(),
                    )
                ],
              ),
      ),
    );
  }
}

class _CycleRhythmPainter extends CustomPainter {
  final List<PeriodLogEntry> logEntries;
  final PeriodLogEntry? selectedLog;
  final Color primaryColor;
  final Color onSurfaceColor;

  _CycleRhythmPainter({
    required this.logEntries,
    this.selectedLog,
    required this.primaryColor,
    required this.onSurfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (logEntries.isEmpty) return;

    final double dayWidth = 50.0;
    final double maxHeight = size.height - 40;
    final Paint linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
      
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor.withValues(alpha: 0.4), primaryColor.withValues(alpha: 0.05)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
    final Path path = Path();
    final Path fillPath = Path();

    final points = logEntries.map((log) {
      final index = logEntries.indexOf(log);
      final x = index * dayWidth + dayWidth / 2;
      final y = size.height - 20 - (log.flow * (maxHeight / 5));
      return Offset(x, y);
    }).toList();

    path.moveTo(points.first.dx, points.first.dx);
    fillPath.moveTo(0, size.height-20);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPointX = p0.dx + (p1.dx - p0.dx) / 2;
      path.quadraticBezierTo(p0.dx, p0.dy, controlPointX, (p0.dy + p1.dy) / 2);
      fillPath.quadraticBezierTo(p0.dx, p0.dy, controlPointX, (p0.dy + p1.dy) / 2);
    }
    
    path.lineTo(points.last.dx, points.last.dy);
    fillPath.lineTo(points.last.dx, points.last.dy);
    fillPath.lineTo(size.width, size.height-20);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < logEntries.length; i++) {
      final log = logEntries[i];
      final point = points[i];
      final isSelected = selectedLog?.id == log.id;

      if (isSelected) {
        canvas.drawCircle(point, 10, Paint()..color = primaryColor);
        canvas.drawCircle(point, 10, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3);
      }

      if (i == 0 || logEntries[i].date.month != logEntries[i - 1].date.month) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: DateFormat('MMM').format(log.date),
            style: TextStyle(color: onSurfaceColor, fontSize: 12),
          ),
        )..layout();
        textPainter.paint(canvas, Offset(point.dx - textPainter.width/2, size.height - 15));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CycleRhythmPainter oldDelegate) {
    return oldDelegate.logEntries != logEntries || oldDelegate.selectedLog != selectedLog;
  }
}