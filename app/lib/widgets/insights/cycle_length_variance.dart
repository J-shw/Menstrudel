import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:menstrudel/models/periods/period.dart';

class CycleLengthVarianceWidget extends StatelessWidget {
  final List<PeriodEntry> periods;

  const CycleLengthVarianceWidget({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (periods.length < 2) {
      return const Card(child: Padding(padding: EdgeInsets.all(24.0), child: Center(child: Text("Need at least two cycles to show variance."))));
    }

    final List<double> cycleLengths = [];
    final List<PeriodEntry> reversedPeriods = periods.reversed.toList();

    for (int i = 0; i < reversedPeriods.length - 1; i++) {
      final currentPeriod = reversedPeriods[i];
      final nextPeriod = reversedPeriods[i + 1];
      final length = nextPeriod.startDate.difference(currentPeriod.startDate).inDays;
      cycleLengths.add(length.toDouble());
    }

    final double avgCycle = cycleLengths.isNotEmpty ? cycleLengths.reduce((a, b) => a + b) / cycleLengths.length : 0;
    final double avgDuration = periods.map((p) => p.totalDays).reduce((a, b) => a + b) / periods.length;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cycle & Period Variance', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Average Cycle: ${avgCycle.toStringAsFixed(0)} days  •  Average Period: ${avgDuration.toStringAsFixed(1)} days', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 10, getDrawingHorizontalLine: (value) => FlLine(color: colorScheme.onSurface.withValues(alpha: 0.1), strokeWidth: 1)),
                  barGroups: List.generate(reversedPeriods.length, (index) {
                    final period = reversedPeriods[index];
                    final double cycleLength = index < cycleLengths.length ? cycleLengths[index] : 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(toY: period.totalDays.toDouble(), color: colorScheme.primary.withValues(alpha: 0.6), width: 12),
                        BarChartRodData(toY: cycleLength, color: colorScheme.tertiary, width: 12),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                     topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                     rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                     leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 10)),
                     bottomTitles: AxisTitles(
                       sideTitles: SideTitles(
                         showTitles: true,
                         reservedSize: 30,
                         getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= reversedPeriods.length) return const SizedBox.shrink();
                            return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(reversedPeriods[index].monthLabel, style: textTheme.bodySmall));
                         },
                       ),
                     )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}