import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/cycles/cycle_stats.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/insights/stat_chip.dart';

class CycleLengthVarianceWidget extends StatelessWidget {
  final List<Period> periods;
  final CycleStats? cycleStats;


  const CycleLengthVarianceWidget({
    super.key,
    required this.periods,
    this.cycleStats,
    });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
 
    if (cycleStats == null || cycleStats!.cycleLengths.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(l10n.cycleLengthVarianceWidget_logAtLeastTwoPeriods),
          ),
        ),
      );
    }

    final List<int> reversedCycleLengths = cycleStats!.cycleLengths.reversed.toList();
    final List<Period> reversedPeriods = periods.reversed.toList();

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cycleLengthVarianceWidget_title, 
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio:
                  3.5,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StatChip(
                  label: l10n.cycleLengthVarianceWidget_averageCycle,
                  value: l10n.dayCount(cycleStats!.averageCycleLength),
                  color: colorScheme.primary,
                ),
                StatChip(
                  label: l10n.shortest,
                  value: l10n.dayCount(cycleStats!.shortestCycleLength!),
                  color: colorScheme.secondary,
                ),
                StatChip(
                  label: l10n.longest,
                  value: l10n.dayCount(cycleStats!.longestCycleLength!),
                  color: colorScheme.secondary,
                ),
                StatChip(
                  label: l10n.total,
                  value: cycleStats!.cycleLengths.length.toString(),
                  color: colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5, 
                    getDrawingHorizontalLine: (value) => FlLine(color: colorScheme.onSurface.withValues(alpha: 0.1), strokeWidth: 1),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => colorScheme.secondary,
                      tooltipBorder: BorderSide(color: colorScheme.onSecondary.withValues(alpha: 0.2)),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final period = reversedPeriods[groupIndex];
                        final String month = period.monthLabel;
                        
                        if (rod.toY == 0) return null;

                        return BarTooltipItem(
                          '$month\n${l10n.cycleLengthVarianceWidget_cycle}: ${l10n.dayCount(rod.toY.toInt())}',
                          TextStyle(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  barGroups: List.generate(reversedCycleLengths.length, (index) {
                    final double cycleLength = reversedCycleLengths[index].toDouble();
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: cycleLength,
                          color: colorScheme.tertiary, 
                          width: 24, 
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 5)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= reversedPeriods.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(reversedPeriods[index].monthLabel, style: textTheme.bodySmall),
                          );
                        },
                      ),
                    ),
                  ),
                  maxY: cycleStats!.longestCycleLength != null ? ((cycleStats!.longestCycleLength! + 5) / 5).round() * 5.0 : null,
                  minY: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}