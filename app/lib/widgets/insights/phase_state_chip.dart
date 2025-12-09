import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';

class PhaseStatusWidget extends StatelessWidget {
  final CyclePhaseResult phaseResult;
  final AppLocalizations l10n;

  const PhaseStatusWidget({
    super.key,
    required this.phaseResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final phase = phaseResult.phase;
    final phaseColor = phase.color;
    final phaseIcon = phase.icon;
    
    String countdownText;
    if (phaseResult.phase == CyclePhase.unknown) {
      countdownText = "";
    }else if (phaseResult.daysRemainingInPhase > 0) {
      countdownText = l10n.countdown_daysLeft(phaseResult.daysRemainingInPhase); 
    } else if (phaseResult.daysInPhase > 0) {
      countdownText = l10n.countdown_overdueByDays(phaseResult.daysInPhase); 
    } else {
      countdownText = l10n.ongoing; 
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: phaseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Icon(
              phaseIcon,
              color: phaseColor,
              size: 18,
            ),

            const SizedBox(width: 8.0),

            Text(
              phase.getDisplayName(l10n),
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: phaseColor.withValues(alpha: 0.95),
              ),
            ),
            
            const SizedBox(width: 12.0),
            
            Text(
              '· $countdownText',
              style: textTheme.bodyMedium?.copyWith(
                color: phaseColor.withValues(alpha: 0.7),
              ),
            ),
            ],
          ),

          const SizedBox(height: 6.0),

          Text(
            phase.getDescription(l10n),
            style: textTheme.bodySmall?.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}