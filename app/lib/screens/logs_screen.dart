import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/models/period_logs/period_day.dart';
import 'package:menstrudel/screens/main_screen.dart';
import 'package:menstrudel/widgets/dialogs/reminder_countdown_dialog.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/logs/dynamic_history_view.dart';
import 'package:menstrudel/widgets/sheets/period_details_bottom_sheet.dart';

class LogsScreen extends StatefulWidget {
  final Function(FabState) onFabStateChange;
  final bool isReminderButtonAlwaysVisible;

  const LogsScreen({
    super.key,
    required this.onFabStateChange,
    required this.isReminderButtonAlwaysVisible,
  });

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PeriodService>().loadInitialData(context);
    });
  }

  Future<void> handleTamponReminderCountdown(PeriodService service) async {
    final dueDate = await NotificationService.getTamponReminderScheduledTime();

    if (dueDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.logScreen_couldNotCancelReminder)),
        );
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ReminderCountdownDialog(
          dueDate: dueDate,
          onDelete: () => service.handleCancelReminder(context),
        ),
      );
    }
  }

  void _showDetailsBottomSheet(PeriodService service, PeriodDay log) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return PeriodDetailsBottomSheet(
          log: log,
          onDelete: () => service.deleteExistingLog(context, log.id),
          onSave: (updatedLog) => service.updateExistingLog(context, updatedLog),
        );
      },
    );
  }

  /// This method now reads state from PeriodService to determine the FabState
  void _updateFabState(PeriodService service) {
    FabState currentState;
    if (!service.isPeriodOngoing && !widget.isReminderButtonAlwaysVisible) {
      currentState = FabState.logPeriod;
    } else {
      currentState = service.isTamponReminderSet ? FabState.cancelReminder : FabState.setReminder;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFabStateChange(currentState);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final periodService = context.watch<PeriodService>();

    _updateFabState(periodService);

    String predictionText = '';
    if (periodService.isLoading) {
      predictionText = l10n.logsScreen_calculatingPrediction;
    } else if (periodService.predictionResult == null) {
      predictionText = l10n.logScreen_logAtLeastTwoPeriods;
    } else {
      final prediction = periodService.predictionResult!;
      String datePart = DateFormat('dd/MM/yyyy').format(prediction.estimatedStartDate);
      if (prediction.daysUntilDue > 0) {
        predictionText = '${l10n.logScreen_nextPeriodEstimate}: $datePart';
      } else if (prediction.daysUntilDue == 0) {
        predictionText = '${l10n.logScreen_periodDueToday} $datePart';
      } else { // overdue
        predictionText = '${l10n.logScreen_periodOverdueBy(-prediction.daysUntilDue)}: $datePart';
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
          onLogRequested: (date) => periodService.createNewLog(context, date),
          onLogTapped: (log) => _showDetailsBottomSheet(periodService, log),
        ),
      ],
    );
  }
}