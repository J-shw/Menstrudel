import 'package:flutter/material.dart';
import 'package:menstrudel/models/pills/pill_intake.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'pill_circle.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/pills/pill_status_enum.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.pillPackVisualiser_yourPack, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
              visualStatus = visualStatus == PillVisualStatus.taken ? PillVisualStatus.taken : PillVisualStatus.placebo;
            }

            return PillCircle(dayNumber: dayNumber, status: visualStatus);
          },
        ),
      ],
    );
  }
}