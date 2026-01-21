import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/basic_progress_circle.dart';

class LogsScreenPeriodQuickViewTab extends StatelessWidget {
  final PeriodService periodService;

  const LogsScreenPeriodQuickViewTab({super.key, required this.periodService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = periodService.isLoading;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    String predictionText = '';
    String datePart = '';
    
    if (periodService.predictionResult == null) {
      predictionText = l10n.logScreen_logAtLeastTwoPeriods;
    } else {
      final prediction = periodService.predictionResult!;
      datePart = DateFormat('dd/MM/yyyy').format(prediction.estimatedStartDate);
      
      if (prediction.daysUntilDue > 0) {
        predictionText = l10n.logScreen_nextPeriodEstimate;
      } else if (prediction.daysUntilDue == 0) {
        predictionText = l10n.logScreen_periodDueToday;
      } else {
        predictionText = l10n.logScreen_periodOverdueBy(-prediction.daysUntilDue);
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