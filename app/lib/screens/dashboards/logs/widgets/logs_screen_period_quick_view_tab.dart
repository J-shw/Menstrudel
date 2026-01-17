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
    final isLoading = periodService.isLoading;

    if (isLoading) return const Center(child: CircularProgressIndicator());

    String predictionText = '';
    if (periodService.isLoading) {
      predictionText = l10n.logsScreen_calculatingPrediction;
    } else if (periodService.predictionResult == null) {
      predictionText = l10n.logScreen_logAtLeastTwoPeriods;
    } else {
      final prediction = periodService.predictionResult!;
      String datePart = DateFormat(
        'dd/MM/yyyy',
      ).format(prediction.estimatedStartDate);
      if (prediction.daysUntilDue > 0) {
        predictionText = '${l10n.logScreen_nextPeriodEstimate}: $datePart';
      } else if (prediction.daysUntilDue == 0) {
        predictionText = '${l10n.logScreen_periodDueToday} $datePart';
      } else {
        // overdue
        predictionText =
            '${l10n.logScreen_periodOverdueBy(-prediction.daysUntilDue)}: $datePart';
      }
    }

    return Center( child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BasicProgressCircle(
          currentValue: periodService.circleCurrentValue,
          maxValue: periodService.circleMaxValue,
          circleSize: 220,
          strokeWidth: 20,
          progressColor: const Color.fromARGB(255, 255, 118, 118),
          trackColor: const Color.fromARGB(20, 255, 118, 118),
        ),
        const SizedBox(height: 15),
        Text(
          predictionText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ],
    ),
    );
  }
}
