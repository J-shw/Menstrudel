import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_data.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';

class FlowPatternsWidget extends StatelessWidget {
  final List<MonthlyFlowData> monthlyFlowData;

  const FlowPatternsWidget({
    super.key,
    required this.monthlyFlowData,
  });

  double _numericFromFlow(FlowRate flow) => flow.index.toDouble() + 1;

  Widget _getFlowLabel(BuildContext context, double value, TextStyle? style) {
    final l10n = AppLocalizations.of(context)!;
    final index = value.round() - 1;

    if (index >= 0 && index < FlowRate.values.length) {
      final flow = FlowRate.values[index];
      if (flow == FlowRate.none) {
        return const SizedBox.shrink();
      }
      return Text(flow.getDisplayName(l10n), style: style);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    if (monthlyFlowData.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text(l10n.monthlyFlowChartWidget_noDataToDisplay)),
        ),
      );
    }
    
    final List<LineChartBarData> cycleLines = [];
    double maxDay = 0;

    for (final monthData in monthlyFlowData) {
      final List<FlSpot> spotsForThisCycle = [];
      for (int i = 0; i < monthData.flows.length; i++) {
        final day = i + 1;
        final flow = FlowRate.values[monthData.flows[i]];
        if (flow == FlowRate.none) {
          continue;
        }
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

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.monthlyFlowChartWidget_cycleFlowPatterns,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.monthlyFlowChartWidget_cycleFlowPatternsDescription,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  minY: 1,
                  maxY: 5,
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
                        reservedSize: 70,
                        interval: 1,
                        getTitlesWidget: (value, meta) => _getFlowLabel(context, value, textTheme.bodySmall),
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
                            child: Text('${l10n.day} ${value.toInt()}', style: textTheme.bodySmall),
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
                      strokeWidth: 2,
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