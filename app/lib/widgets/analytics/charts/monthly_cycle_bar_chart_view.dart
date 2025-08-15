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

  Color _getColorForCycle(int cycleLength) {
    if (cycleLength <= 24) return const Color(0xFFFF9999);
    if (cycleLength <= 35) return const Color.fromARGB(255, 255, 102, 102);
    return const Color(0xFFCC0000);
  }

  @override
  Widget build(BuildContext context) {
    final data = monthlyCycleData;
    if (data == null || data.isEmpty) {
      return const Center(
        child: Text('Not enough data for cycle length chart.'),
      );
    }

    final allLengths = data.map((d) => d.cycleLength).toList();
    final double averageCycleLength = allLengths.reduce((a, b) => a + b) / allLengths.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: averageCycleLength,
                color: Theme.of(context).colorScheme.secondary,
                strokeWidth: 2,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  labelResolver: (line) => 'Avg ${line.y.toStringAsFixed(0)}',
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
                  color: _getColorForCycle(cycleData.cycleLength),
                  width: 25,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Text(
                      data[index].cycleLength.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    final cycle = data[index];
                    final monthLabel = DateFormat('MMM').format(DateTime(cycle.year, cycle.month));
                    return Text(monthLabel, style: const TextStyle(fontSize: 12));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: (allLengths.reduce(max) / 5).ceil() * 5.0 + 5,
          minY: 0,
        ),
      ),
    );
  }
}