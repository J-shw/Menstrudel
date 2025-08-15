import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/cycles/monthly_cycle_data.dart';

class MonthlyCycleListView extends StatelessWidget {
  final List<MonthlyCycleData>? monthlyCycleData;
  final double barHeight;

  const MonthlyCycleListView({
    super.key,
    this.monthlyCycleData,
    this.barHeight = 35.0,
  });

  Color _getColorForCycle(int cycleLength, ColorScheme colorScheme) {
    const Color lightColor = Color.fromARGB(255, 255, 153, 153);
    const Color mediumColor = Color.fromARGB(255, 255, 102, 102);
    const Color darkColor = Color.fromARGB(255, 204, 0, 0);

    final Color themeColor = colorScheme.primaryContainer;

    Color blend(Color yourColor) {
      return Color.lerp(themeColor, yourColor, 0.7)!;
    }


    if (cycleLength <= 24) {
      return blend(lightColor);
    }
    else if (cycleLength <= 35) {
      return blend(mediumColor);
    }
    else {
      return blend(darkColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (monthlyCycleData == null || monthlyCycleData!.isEmpty) {
      return const Center(
        child: Text(
          'Not enough data for monthly cycle graph.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: monthlyCycleData!.length,
      itemBuilder: (context, index) {
        final data = monthlyCycleData![monthlyCycleData!.length - 1 - index];
        final String monthName = DateFormat('MMMM').format(DateTime(data.year, data.month));
        
        final double barWidthFactor = ((data.cycleLength.clamp(15, 40) - 15) / (40 - 15)) * 0.8 + 0.2;

        final barColor = _getColorForCycle(data.cycleLength, colorScheme);
        final brightness = ThemeData.estimateBrightnessForColor(barColor);
        final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  monthName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              FractionallySizedBox(
                widthFactor: barWidthFactor,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(barHeight / 2),
                  ),
                  child: Center(
                    child: Text(
                      '${data.cycleLength} days',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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