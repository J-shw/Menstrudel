import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/flows/flow_enum.dart';
import 'package:menstrudel/widgets/sheets/symptom_entry_sheet.dart';
import 'package:menstrudel/models/period_logs/log_day.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:provider/provider.dart';

class PeriodLoggerService {
  static Future<bool> showAndLogPeriod(BuildContext context, DateTime selectedDate) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SymptomEntrySheet(selectedDate: selectedDate),
    );
    final periodsRepo = PeriodsRepository();

    if (result == null || !context.mounted) {
      return false; 
    }

    try {
      final DateTime? date = result['date'];
      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Date was not provided.')),
        );
        return false; // Failure
      }

      final newEntry = LogDay(
        date: date,
        symptoms: result['symptoms'] ?? [],
        flow: result['flow'] ?? FlowRate.none,
        painLevel: result['painLevel'],
      );

      try {
        await periodsRepo.createPeriodLog(newEntry);
        if (newEntry.flow != FlowRate.none && context.mounted) {
          final settingsService = context.read<SettingsService>();
          final nextDay = newEntry.date.add(const Duration(days: 1));
          final reminderTime = settingsService.loggingReminderTime;
          final bool isReminderEnabled = settingsService.isLoggingReminderNotificationEnabled;
          final l10n = AppLocalizations.of(context)!;

          final scheduledTime = DateTime(
            nextDay.year,
            nextDay.month,
            nextDay.day,
            reminderTime.hour,
            reminderTime.minute,
          );

          NotificationService.scheduleLoggingReminder(
            scheduledTime: scheduledTime,
            isEnabled: isReminderEnabled,
            title: l10n.settingsScreen_loggingReminderTitle,
            body: l10n.settingsScreen_loggingReminderBody,
          );
          
        }
      } on DuplicateLogException catch (e) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        return false;
      } on FutureDateException catch (e) { 
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        return false;
      }

      if (context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log saved!')),
        );
      }
      return true;

    } catch (e) {
      debugPrint('Error logging period: $e');
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save log. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
  }
}