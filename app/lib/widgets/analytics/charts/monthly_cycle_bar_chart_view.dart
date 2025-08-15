import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';

class CycleLengthBarChart extends StatelessWidget {
  final List<MonthlyCycleData>? monthlyCycleData;

  const CycleLengthBarChart({
    super.key,
    this.monthlyCycleData,
  });

  LinearGradient _getBarGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        Theme.of(context).colorScheme.secondary,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = monthlyCycleData;
    if (data == null || data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            heightFactor: 3,
            child: Text('Not enough data for cycle length chart.'),
          ),
        ),
      );
    }

    final allLengths = data.map((d) => d.cycleLength).toList();
    final double averageCycleLength = allLengths.reduce((a, b) => a + b) / allLengths.length;
    final double maxYValue = allLengths.reduce(max).toDouble();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                // Using the correct parameters you provided
                getTooltipColor: (_) => Colors.blueGrey.withValues(alpha: 0.9),
                tooltipBorderRadius: BorderRadius.circular(8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()} days',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value == 0 || value > maxYValue) return const SizedBox.shrink();
                    return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      final cycle = data[index];
                      final monthLabel = DateFormat('MMM').format(DateTime(cycle.year, cycle.month));
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(monthLabel, style: const TextStyle(fontSize: 12)),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),

            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 10,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                strokeWidth: 1,
              ),
            ),
            
            alignment: BarChartAlignment.spaceBetween,
            maxY: maxYValue + 5,
            minY: 0,
            
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: averageCycleLength,
                  color: Theme.of(context).colorScheme.tertiary,
                  strokeWidth: 2,
                  dashArray: [8, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 4, bottom: 2),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    labelResolver: (line) => 'Avg: ${line.y.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),
            
            barGroups: data.asMap().entries.map((entry) {
              final index = entry.key;
              final cycleData = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: cycleData.cycleLength.toDouble(),
                    gradient: _getBarGradient(context),
                    width: 20,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                ],
              );
            }).toList(),
          ),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}