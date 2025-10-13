import 'package:flutter/material.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'pill_circle.dart';
import 'package:menstrudel/models/pills/pill_status_enum.dart';

class PillPackVisualiser extends StatelessWidget {
  final PillRegimen activeRegimen;
  final List<PillIntake> intakes;
  final int currentPillNumberInCycle;
  final int selectedPillNumber;
  final ValueChanged<int> onPillTapped;

  const PillPackVisualiser({
    super.key,
    required this.activeRegimen,
    required this.intakes,
    required this.currentPillNumberInCycle,
    required this.selectedPillNumber,
    required this.onPillTapped,
  });

  @override
  Widget build(BuildContext context) {
    final totalPills = activeRegimen.activePills + activeRegimen.placeboPills;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(activeRegimen.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
            PillVisualStatus visualStatus;


            if (intakeRecord != null) {
              visualStatus = PillVisualStatus.fromIntakeStatus(intakeRecord.status);
            } else if (dayNumber == currentPillNumberInCycle) {
              visualStatus = PillVisualStatus.today;
            } else if (dayNumber < currentPillNumberInCycle) {
              visualStatus = PillVisualStatus.missed;
            } else {
              visualStatus = PillVisualStatus.future;
            }
            
            if (dayNumber > activeRegimen.activePills) {
              if (visualStatus != PillVisualStatus.taken && visualStatus != PillVisualStatus.skipped) {
                visualStatus = PillVisualStatus.placebo;
              }
            }

            final bool isSelected = dayNumber == selectedPillNumber; 
            
            final bool isEditable = dayNumber < currentPillNumberInCycle; 

            return GestureDetector(
              onTap: isEditable || dayNumber == currentPillNumberInCycle
                  ? () => onPillTapped(dayNumber)
                  : null,
              child: PillCircle(
                dayNumber: dayNumber, 
                status: visualStatus,
                isSelected: isSelected,
              ),
            );

          },
        ),
      ],
    );
  }
}