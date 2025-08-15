import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';

class CycleLengthBarChart extends StatelessWidget {
  final List<MonthlyCycleData>? monthlyCycleData;

  const CycleLengthBarChart({
    super.key,
    this.monthlyCycleData,
  });

  @override
  Widget build(BuildContext context) {
    final data = monthlyCycleData;
    if (data == null || data.isEmpty) {
      return const Center(
        child: Text('Not enough data for cycle length chart.'),
      );
    }

    final allLengths = data.map((d) => d.cycleLength).toList();
    final minDataValue = allLengths.reduce(min);
    final maxDataValue = allLengths.reduce(max);
    int minAxisValue = (minDataValue / 5).floor() * 5;
    int maxAxisValue = (maxDataValue / 5).ceil() * 5;
    
    if (minAxisValue == maxAxisValue) {
      minAxisValue = max(0, minAxisValue - 5);
      maxAxisValue = maxAxisValue + 5;
    }

    final double averageCycleLength = allLengths.reduce((a, b) => a + b) / allLengths.length;

    final textTheme = Theme.of(context).textTheme;
    final reversedData = data.reversed.toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: reversedData.map((cycleData) {
            return Expanded(
              child: Text(
                '${cycleData.cycleLength}',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartHeight = constraints.maxHeight;
              final double range = (maxAxisValue - minAxisValue).toDouble();

              final double averageHeightFactor = range == 0 ? 0.0 : (averageCycleLength.clamp(minAxisValue, maxAxisValue) - minAxisValue) / range;
              final double averageLineBottomPosition = chartHeight * averageHeightFactor;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: reversedData.map((cycleData) {
                        return _ChartBar(
                          cycleData: cycleData,
                          minAxisValue: minAxisValue,
                          maxAxisValue: maxAxisValue,
                        );
                      }).toList(),
                    ),
                  ),

                  if (averageLineBottomPosition.isFinite)
                    Positioned(
                      bottom: averageLineBottomPosition,
                      left: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Avg ${averageCycleLength.toStringAsFixed(0)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 4),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: reversedData.map((cycleData) {
            final monthLabel = DateFormat('MMM').format(DateTime(cycleData.year, cycleData.month));
            return Expanded(
              child: Text(
                monthLabel,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ChartBar extends StatelessWidget {
  final MonthlyCycleData cycleData;
  final int minAxisValue;
  final int maxAxisValue;

  const _ChartBar({
    required this.cycleData,
    required this.minAxisValue,
    required this.maxAxisValue,
  });

  Color _getColorForCycle(int cycleLength, ColorScheme colorScheme) {
    const Color shortColor = Color(0xFFFF9999);
    const Color normalColor = Color.fromARGB(255, 255, 102, 102);
    const Color longColor = Color(0xFFCC0000);

    final Color baseColor = cycleLength <= 24
        ? shortColor
        : cycleLength <= 35
            ? normalColor
            : longColor;

    return Color.lerp(colorScheme.primaryContainer, baseColor, 0.7) ?? baseColor;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final range = (maxAxisValue - minAxisValue).toDouble();
    
    final double barHeightFactor = range == 0.0 ? 0.0 : (cycleData.cycleLength.clamp(minAxisValue, maxAxisValue) - minAxisValue) / range;

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: barHeightFactor.isNaN ? 0.0 : barHeightFactor,
          child: Container(
            constraints: const BoxConstraints(minWidth: 40),
            decoration: BoxDecoration(
              color: _getColorForCycle(cycleData.cycleLength, colorScheme),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}