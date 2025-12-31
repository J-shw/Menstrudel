import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/controllers/log_ui_controller.dart';
import 'package:menstrudel/services/log_service.dart';
import 'package:menstrudel/services/widget_controller.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/widgets/logs/dynamic_history_view.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PeriodService>().refreshData(
            currentLogs: context.read<LogService>().logs,
            l10n: AppLocalizations.of(context)!,
            widgetController: context.read<WidgetController>(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final periodService = context.watch<PeriodService>();

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

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),
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
        const SizedBox(height: 20),
        DynamicHistoryView(
          onLogRequested: (date) {
            context.read<LogUIController>().handleCreateNewLog(
                  context: context,
                  selectedDate: date,
                );
          },
          onLogTapped: (log) => context.read<LogUIController>().handleEditLog(
            context: context,
            log: log,
          ),
        ),
      ],
    );
  }
}