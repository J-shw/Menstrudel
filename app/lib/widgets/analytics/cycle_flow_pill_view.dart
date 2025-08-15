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

  Color _getColorForFlow(FlowLevel flow) {
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

                      return Expanded(
                        child: Container(
                          color: _getColorForFlow(flowLevel),
                          child: Center(
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                color: Colors.white,
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