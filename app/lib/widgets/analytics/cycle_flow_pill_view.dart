import 'package:flutter/material.dart';
import 'package:menstrudel/models/flows/flow_data.dart';


class CycleFlowPillView extends StatelessWidget {
  final List<DailyFlowData>? cycleFlowData;
  final double height;

  const CycleFlowPillView({
    super.key,
    this.cycleFlowData,
    this.height = 40.0,
  });

  Color _getColorForFlow(FlowLevel flow, ColorScheme colorScheme) {
    switch (flow) {
      case FlowLevel.light:
        return const Color.fromARGB(255, 255, 153, 153); 
      case FlowLevel.medium:
        return const Color.fromARGB(255, 255, 102, 102);
      case FlowLevel.heavy:
        return const Color.fromARGB(255, 204, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (cycleFlowData == null || cycleFlowData!.isEmpty) {
      return Center(
        child: Text(
          'Not enough data for flow rate chart.',
          style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Flow Rate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          
          Container(
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: Row(
                children: cycleFlowData!.map((data) {
                  return Expanded(
                    child: Container(
                      color: _getColorForFlow(data.flow, colorScheme),
                      child: Center(
                        child: Text(
                          '${data.day}',
                          style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
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
  }
}