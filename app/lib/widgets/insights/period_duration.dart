import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:menstrudel/models/periods/period.dart';
import 'package:menstrudel/models/periods/period_stats.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/utils/period_predictor.dart';

class PeriodDurationWidget extends StatelessWidget {
  final List<Period> periods;

  const PeriodDurationWidget({super.key, required this.periods});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final PeriodStats? periodStats = PeriodPredictor.getPeriodStats(periods); 
    final List<Period> reversedPeriods = List.from(periods)
        ..sort((a, b) => a.startDate.compareTo(b.startDate))
        ..reversed.toList();


    if (periodStats == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(l10n.periodDurationWidget_logAtLeastTwoPeriods), 
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.periodDurationWidget_title, 
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.periodDurationWidget_averagePeriod}: ${l10n.dayCount(periodStats.averageLength)} • ${l10n.shortest}: ${l10n.dayCount(periodStats.shortestLength!)} • ${l10n.longest}: ${l10n.dayCount(periodStats.longestLength!)}',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
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
                    horizontalInterval: 1, 
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
                          '$month\n${l10n.periodDurationWidget_period}: ${l10n.dayCount(rod.toY.toInt())}',
                          TextStyle(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  barGroups: List.generate(reversedPeriods.length, (index) {
                    final double duration = reversedPeriods[index].totalDays.toDouble();
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: duration,
                          color: colorScheme.primary.withValues(alpha: 0.8), 
                          width: 24, 
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1)),
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
                  maxY: periodStats.longestLength != null ? (periodStats.longestLength! + 2).toDouble() : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}