import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/services/log_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/widget_controller.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/sheets/symptom_entry_sheet.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/widgets/logs/dynamic_history_view.dart';
import 'package:menstrudel/widgets/sheets/period_details_bottom_sheet.dart';

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

  Future<void> _handleCreateNewLog(DateTime selectedDate) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SymptomEntrySheet(selectedDate: selectedDate),
    );

    if (result == null || !mounted) return;

    final logService = context.read<LogService>();
    final periodService = context.read<PeriodService>();
    final l10n = AppLocalizations.of(context)!;
    final widgetController = context.read<WidgetController>();
    final settings = context.read<SettingsService>();

    try {
      final newEntry = LogDay(
        date: result['date'],
        symptoms: result['symptoms'] ?? [],
        flow: result['flow'] ?? FlowRate.none,
        painLevel: result['painLevel'],
      );

      await logService.saveLog(newEntry);

      if (mounted) {
        await periodService.scheduleLoggingReminder(
          log: newEntry,
          settings: settings,
          l10n: l10n,
        );

        await periodService.refreshData(
          currentLogs: logService.logs,
          l10n: l10n,
          widgetController: widgetController,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log saved!')),
          );
        }
      }
    } on DuplicateLogException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on FutureDateException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An unexpected error occurred")));
      }
    }
  }

  void _showEditLogBottomSheet(
    PeriodService periodService,
    LogService logService,
    LogDay log,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return PeriodDetailsBottomSheet(
          log: log,
          onDelete: () async {
            final l10n = AppLocalizations.of(context)!;
            final widgetController = context.read<WidgetController>();

            await logService.deleteLog(log.id!);

            if (context.mounted) {
              await periodService.refreshData(
                currentLogs: logService.logs,
                l10n: l10n,
                widgetController: widgetController,
              );
              if (context.mounted) Navigator.pop(context);
            }
          },
          onSave: (updatedLog) async {
            final l10n = AppLocalizations.of(context)!;
            final widgetController = context.read<WidgetController>();
            final settings = context.read<SettingsService>();

            await logService.saveLog(updatedLog);

            if (context.mounted) {
              await periodService.scheduleLoggingReminder(
                log: updatedLog,
                settings: settings,
                l10n: l10n,
              );

              await periodService.refreshData(
                currentLogs: logService.logs,
                l10n: l10n,
                widgetController: widgetController,
              );

              if (context.mounted) Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final periodService = context.watch<PeriodService>();
    final logService = context.watch<LogService>();

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
          onLogRequested: (date) => _handleCreateNewLog,
          onLogTapped: (log) =>
              _showEditLogBottomSheet(periodService, logService, log),
        ),
      ],
    );
  }
}