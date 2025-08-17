import 'package:flutter/material.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'pill_circle.dart';

enum PillStatus { taken, today, future, placebo, missed }

class PillPackVisualiser extends StatelessWidget {
  final PillRegimen activeRegimen;
  final List<PillIntake> intakes;
  final int currentPillNumberInCycle;

  const PillPackVisualiser({
    super.key,
    required this.activeRegimen,
    required this.intakes,
    required this.currentPillNumberInCycle,
  });

  @override
  Widget build(BuildContext context) {
    final totalPills = activeRegimen.activePills + activeRegimen.placeboPills;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Pack', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: totalPills,
          itemBuilder: (context, index) {
            final dayNumber = index + 1;
            final intakeRecord = intakes.where((i) => i.pillNumberInCycle == dayNumber).firstOrNull;
            PillStatus status;

            if (intakeRecord != null) {
              status = PillStatus.taken;
            } else if (dayNumber == currentPillNumberInCycle) {
              status = PillStatus.today;
            } else if (dayNumber < currentPillNumberInCycle) {
              status = PillStatus.missed;
            } else {
              status = PillStatus.future;
            }
            
            if (dayNumber > activeRegimen.activePills) {
              status = status == PillStatus.taken ? PillStatus.taken : PillStatus.placebo;
            }

            return PillCircle(dayNumber: dayNumber, status: status);
          },
        ),
      ],
    );
  }
}