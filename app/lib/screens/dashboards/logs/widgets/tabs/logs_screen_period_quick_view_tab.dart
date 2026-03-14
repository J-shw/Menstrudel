import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/cycle_phase/cycle_phase_enum.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/basic_progress_circle.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';

class LogsScreenPeriodQuickViewTab extends StatelessWidget {
  final PeriodService periodService;


  const LogsScreenPeriodQuickViewTab({super.key, required this.periodService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = periodService.isLoading;
    final settingsService = context.read<SettingsService>();

    if (isLoading) return const Center(child: CircularProgressIndicator());

    String predictionText = '';
    String datePart = '';
    
    if (periodService.upcomingPeriodPrediction == null) {
      predictionText = l10n.logScreen_logAtLeastTwoPeriods;
    } else {
      final prediction = periodService.upcomingPeriodPrediction!;
      
      datePart = DateFormat('dd/MM/yyyy').format(prediction.estimatedStartDate);
      
      if (prediction.daysUntilDue > 0) {
        predictionText = l10n.logScreen_nextPeriodEstimate;
      } else if (prediction.daysUntilDue == 0) {
        predictionText = l10n.logScreen_periodDueToday;
      } else {
        predictionText = l10n.logScreen_periodOverdueBy(-prediction.daysUntilDue);
      }
    }

    final allPeriods = periodService.periodEntries;
    if (allPeriods.isEmpty) {
      return Center(child: Text(l10n.logScreen_logAtLeastTwoPeriods));
    }

    final predictedCurrentCycle = periodService.predictedCurrentCycle;
    String phaseText = '';
    CyclePhase currentPhase = CyclePhase.unknown;

    if (predictedCurrentCycle != null) {
      currentPhase = predictedCurrentCycle.getPhaseForDate(DateTime.now());
      final daysLeft = predictedCurrentCycle.getDaysLeft(DateTime.now(), currentPhase);

      if (currentPhase == CyclePhase.unknown) {
        phaseText = "";
      } else if (currentPhase == CyclePhase.late) {
        phaseText = currentPhase.getDescription(l10n);
      } else if (currentPhase == CyclePhase.menstruation || periodService.isPeriodOngoing) { // If user does not match their average this will show period ongoing.
        phaseText = l10n.countUp_day(periodService.menstruationDay);
        currentPhase = CyclePhase.menstruation;
      } else if (daysLeft > 0) {
        phaseText = l10n.countdown_daysLeft(daysLeft);
      } else {
        phaseText = l10n.ongoing;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const SizedBox(height: 20),
        Center(
          child: BasicProgressCircle(
            currentValue: periodService.circleCurrentValue,
            maxValue: periodService.circleMaxValue,
            circleSize: 240,
            strokeWidth: 22,
            progressColor: colorScheme.primary,
            trackColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(height: 40),

        _buildStatusCard(
          context,
          icon: Icons.event,
          title: predictionText,
          value: datePart.isNotEmpty ? datePart : "--",
          color: colorScheme.surfaceContainerHighest,
        ),
        if (settingsService.isNaturalCycle && predictedCurrentCycle != null && settingsService.arePhasePredictionsEnabled) ...[
          _buildStatusCard(
            context,
            icon: currentPhase.icon,
            title: currentPhase.getDisplayName(l10n),
            value: phaseText,
            color: currentPhase.color.withValues(alpha: 0.4),
          ),
          if (settingsService.displayFertileChance) ...[
            _buildStatusCard(
              context,
              icon: Icons.pregnant_woman_rounded,
              title: "Fertility Chance",
              value:  predictedCurrentCycle.getFertilityLevel(DateTime.now(), currentPhase, l10n),
              color:  colorScheme.surfaceContainerHighest,
            ),
          ]
        ]
      ],
    );
  }

  // This can be used for future items (Such as pregnancy chance, or current phase etc..)
  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: color,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}