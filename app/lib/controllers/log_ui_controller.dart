import 'package:flutter/material.dart';
import 'package:menstrudel/coordinators/data_refresh_coordinator.dart';
import 'package:menstrudel/services/symptom_service.dart';
import 'package:menstrudel/widgets/sheets/period_details_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:menstrudel/services/log_service.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/sheets/symptom_entry_sheet.dart';

class LogUIController extends ChangeNotifier {

  /// Orchestrates the workflow of showing the entry sheet, saving the log,
  /// and refreshing all dependent services (Predictions, Widgets, Notifications).
  Future<void> handleCreateNewLog({
    required BuildContext context,
    required DateTime selectedDate,
    required SymptomService symptomService,
    required int? age,
  }) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SymptomEntrySheet(selectedDate: selectedDate, symptomService: symptomService, age: age),
    );

    if (result == null || !context.mounted) return;

    final logService = context.read<LogService>();
    final periodService = context.read<PeriodService>();
    final coordinator = context.read<DataRefreshCoordinator>();
    final settings = context.read<SettingsService>();
    final l10n = AppLocalizations.of(context)!;

    try {
      final newEntry = LogDay(
        date: result['date'] ?? selectedDate,
        symptoms: result['symptoms'] ?? [],
        flow: result['flow'] ?? FlowRate.none,
        painLevel: result['painLevel'],
      );

      await logService.saveLog(newEntry);

      if (!context.mounted) return;

      await periodService.scheduleLoggingReminder(
        log: newEntry,
        settings: settings,
        l10n: l10n,
      );

      coordinator.onLogsChanged(l10n);

      if (context.mounted) {
        _showSuccess(context, 'Log saved!'); //TODO: localisation 'logSavedSuccessMessage'
      }
    } on DuplicateLogException catch (e) {
      if (context.mounted) _showError(context, e.message);
    } on FutureDateException catch (e) {
      if (context.mounted) _showError(context, e.message);
    } catch (_) {
      if (context.mounted) {
        _showError(context, 'An unexpected error occurred'); //TODO: localisation 'unexpectedErrorMessage'
      }
    }
  }

  /// Orchestrates editing or deleting an existing log.
  Future<void> handleEditLog({
    required BuildContext context,
    required LogDay log,
    required SymptomService symptomService,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return PeriodDetailsBottomSheet(
          log: log,
          symptomService: symptomService,
          onDelete: () async {
            final logService = context.read<LogService>();
            final coordinator = context.read<DataRefreshCoordinator>();
            final l10n = AppLocalizations.of(context)!;

            if (log.id == null) {
              _showError(context, 'Cannot delete unsaved log'); //TODO: localisation 'cannotDeleteUnsavedLogMessage'
              return;
            }

            await logService.deleteLog(log.id!);

            coordinator.onLogsChanged(l10n);
          },

          onSave: (updatedLog) async {
            final logService = context.read<LogService>();
            final periodService = context.read<PeriodService>();
            final coordinator = context.read<DataRefreshCoordinator>();
            final settings = context.read<SettingsService>();
            final l10n = AppLocalizations.of(context)!;

            await logService.saveLog(updatedLog);

            if (!context.mounted) return;

            await periodService.scheduleLoggingReminder(
              log: updatedLog,
              settings: settings,
              l10n: l10n,
            );

            coordinator.onLogsChanged(l10n);

            if (sheetContext.mounted) Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}