import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_data.dart';


class CycleFlowPillView extends StatelessWidget {
  final List<MonthlyFlowData> monthlyFlowData;
  final double height;

  const CycleFlowPillView({
    super.key,
    required this.monthlyFlowData,
    this.height = 35.0,
  });

  Color _getColorForFlow(FlowLevel flow, ColorScheme colorScheme) {
    const Color lightColor = Color.fromARGB(255, 255, 153, 153);
    const Color mediumColor = Color.fromARGB(255, 255, 102, 102);
    const Color heavyColor = Color.fromARGB(255, 204, 0, 0);

    final Color themeColor = colorScheme.primaryContainer;

    Color blend(Color yourColor) {
      return Color.lerp(themeColor, yourColor, 0.7)!;
    }

    switch (flow) {
      case FlowLevel.light:
        return blend(lightColor);
      case FlowLevel.medium:
        return blend(mediumColor);
      case FlowLevel.heavy:
        return blend(heavyColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    
    if (monthlyFlowData.isEmpty) {
      return const Center(
        child: Text('Not enough data for flow rate chart.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: monthlyFlowData.length,
      itemBuilder: (context, index) {
        final monthData = monthlyFlowData[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  monthData.monthLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              SizedBox(
                height: height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(height / 2),
                  child: Row(
                    children: monthData.flows.asMap().entries.map((entry) {
                      final dayNumber = entry.key + 1;
                      final flowInt = entry.value;
                      final flowLevel = flowLevelFromInt(flowInt);
                      final segmentColor = _getColorForFlow(flowLevel, colorScheme);
                      final brightness = ThemeData.estimateBrightnessForColor(segmentColor);
                      final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

                      return Expanded(
                        child: Container(
                          color: segmentColor,
                          child: Center(
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}