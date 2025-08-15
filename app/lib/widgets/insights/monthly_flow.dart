import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_data.dart';

class FlowPatternsWidget extends StatelessWidget {
  final List<MonthlyFlowData> monthlyFlowData;

  const FlowPatternsWidget({
    super.key,
    required this.monthlyFlowData,
  });

  double _numericFromFlow(FlowLevel flow) => flow.index.toDouble() + 1;

  Widget _getFlowLabel(double value, TextStyle? style) {
    switch (value.round()) {
      case 1:
        return Text('Light', style: style);
      case 2:
        return Text('Medium', style: style);
      case 3:
        return Text('Heavy', style: style);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (monthlyFlowData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text("No data to display.")),
        ),
      );
    }
    
    final List<LineChartBarData> cycleLines = [];
    double maxDay = 0;

    for (final monthData in monthlyFlowData) {
      final List<FlSpot> spotsForThisCycle = [];
      for (int i = 0; i < monthData.flows.length; i++) {
        final day = i + 1;
        final flow = flowLevelFromInt(monthData.flows[i]);
        spotsForThisCycle.add(FlSpot(day.toDouble(), _numericFromFlow(flow)));
      }

      if (monthData.flows.length > maxDay) {
        maxDay = monthData.flows.length.toDouble();
      }

      cycleLines.add(
        LineChartBarData(
          spots: spotsForThisCycle,
          isCurved: true,
          color: colorScheme.primary.withValues(alpha: 0.4),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cycle Flow Patterns',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Each line represents one complete cycle',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 4,
                  minX: 1,
                  maxX: maxDay,
                  lineBarsData: cycleLines,
                  lineTouchData: const LineTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 1,
                        getTitlesWidget: (value, meta) => _getFlowLabel(value, textTheme.bodySmall),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (maxDay / 6).floorToDouble().clamp(1, 100),
                        getTitlesWidget: (value, meta) {
                          if (value > maxDay || value == 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Day ${value.toInt()}', style: textTheme.bodySmall),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colorScheme.onSurface.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}