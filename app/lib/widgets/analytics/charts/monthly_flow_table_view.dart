import 'dart:math';
import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_data.dart';

const double _kRowHeight = 40.0;
const double _kDayNumberColumnWidth = 30.0;

class CycleFlowTableView extends StatelessWidget {
  final List<MonthlyFlowData> monthlyFlowData;

  const CycleFlowTableView({
    super.key,
    required this.monthlyFlowData,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyFlowData.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxCycleLength = monthlyFlowData.map((d) => d.flows.length).reduce(max);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _kRowHeight,
          child: Row(
            children: [
              SizedBox(width: _kDayNumberColumnWidth),
              ...monthlyFlowData.map(
                (data) => Expanded(
                  child: Center(
                    child: Text(
                      data.monthLabel,
                      style: textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ...List.generate(maxCycleLength, (dayIndex) {
          final dayNumber = dayIndex + 1;
          return SizedBox(
            height: _kRowHeight,
            child: Row(
              children: [
                SizedBox(
                  width: _kDayNumberColumnWidth,
                  child: Center(
                    child: Text('$dayNumber', style: textTheme.bodySmall),
                  ),
                ),
                ...monthlyFlowData.map((monthData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: (dayIndex < monthData.flows.length)
                          ? _DaySegment(
                              flow: flowLevelFromInt(monthData.flows[dayIndex]),
                              colorScheme: colorScheme,
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _DaySegment extends StatelessWidget {
  const _DaySegment({
    required this.flow,
    required this.colorScheme,
  });

  final FlowLevel flow;
  final ColorScheme colorScheme;

  Color _getColorForFlow() {
    const Color lightColor = Color.fromARGB(255, 255, 153, 153);
    const Color mediumColor = Color.fromARGB(255, 255, 102, 102);
    const Color heavyColor = Color.fromARGB(255, 204, 0, 0);

    final Color baseColor;
    switch (flow) {
      case FlowLevel.light:
        baseColor = lightColor;
        break;
      case FlowLevel.medium:
        baseColor = mediumColor;
        break;
      case FlowLevel.heavy:
        baseColor = heavyColor;
        break;
    }
    return Color.lerp(colorScheme.primaryContainer, baseColor, 0.7) ?? baseColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getColorForFlow(),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}