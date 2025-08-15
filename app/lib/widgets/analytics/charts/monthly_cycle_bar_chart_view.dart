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

    final allLengths = data.map((d) => d.cycleLength);
    final minDataValue = allLengths.reduce(min);
    final maxDataValue = allLengths.reduce(max);
    int minAxisValue = (minDataValue / 5).floor() * 5;
    int maxAxisValue = (maxDataValue / 5).ceil() * 5;
    if (minAxisValue == maxAxisValue) {
      minAxisValue = max(0, minAxisValue - 5);
      maxAxisValue = maxAxisValue + 5;
    }

    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((cycleData) {
                return _ChartBar(
                  cycleData: cycleData,
                  minAxisValue: minAxisValue,
                  maxAxisValue: maxAxisValue,);
              }).toList(),
            ),
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

    final Color baseColor;
    if (cycleLength <= 24) {
      baseColor = shortColor;
    } else if (cycleLength <= 35) {
      baseColor = normalColor;
    } else {
      baseColor = longColor;
    }

    return Color.lerp(colorScheme.primaryContainer, baseColor, 0.7) ?? baseColor;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final barHeightFactor =
        (cycleData.cycleLength.clamp(minAxisValue, maxAxisValue) - minAxisValue) /
            (maxAxisValue - minAxisValue);

    final barColor = _getColorForCycle(cycleData.cycleLength, colorScheme);
    final monthLabel = DateFormat('MMM').format(DateTime(cycleData.year, cycleData.month));

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${cycleData.cycleLength}',
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: FractionallySizedBox(
                heightFactor: barHeightFactor,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(monthLabel, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}