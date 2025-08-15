import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';

const double _kChartHeight = 200.0;
const double _kYAxisWidth = 30.0;
const int _kMinYAxisValue = 15;
const int _kMaxYAxisValue = 45; 

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

    return SizedBox(
      height: _kChartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildYAxisLabels(context),
          const VerticalDivider(width: 1),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((cycleData) {
                return _ChartBar(cycleData: cycleData);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabels(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: _kYAxisWidth,
      height: _kChartHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_kMaxYAxisValue}d', style: textTheme.bodySmall),
          Text('${(_kMinYAxisValue + _kMaxYAxisValue) ~/ 2}d', style: textTheme.bodySmall),
          Text('${_kMinYAxisValue}d', style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final MonthlyCycleData cycleData;

  const _ChartBar({required this.cycleData});

  Color _getColorForCycle(int cycleLength, ColorScheme colorScheme) {
    const Color shortColor = Color(0xFFFF9999);
    const Color normalColor = Color(0xFF4CAF50);
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
        (cycleData.cycleLength.clamp(_kMinYAxisValue, _kMaxYAxisValue) - _kMinYAxisValue) /
            (_kMaxYAxisValue - _kMinYAxisValue);

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
                  constraints: const BoxConstraints(minWidth: 20),
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