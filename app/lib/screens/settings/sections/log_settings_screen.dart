import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/symptom_service.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class LogSettingsScreen extends StatelessWidget {
  const LogSettingsScreen({super.key, required this.logsRepo});

  final LogsRepository logsRepo;

  Future<void> _showNewCustomSymptomDialog(BuildContext context, SymptomService symptomService) async {
    
    final (String name, bool isDefault)? result =
        await showDialog<(String, bool)>(
          context: context,
          builder: (BuildContext context) {
            return const CustomSymptomDialog(hideTemporarySwitch: true);
          },
        );

    if (result != null) {
      var symptom = Symptom.fromDbString(result.$1);
      
      if (symptomService.symptoms.contains(symptom)) {
        return;
      }
      
      await symptomService.addSymptom(symptom);
    }
  }

  Future<void> _removeDefaultSymptom(BuildContext context, Symptom symptom, AppLocalizations l10n, SymptomService symptomService) async {    
    final symptomUsageCount = await logsRepo.getSingleSymptomFrequency(
      symptom,
    );

    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_deleteDefaultSymptomQuestion(
            symptom.getDisplayName(l10n),
          ),
          contentText: l10n.settingsScreen_deleteDefaultSymptomDescription(
            symptom.getDisplayName(l10n),
            symptomUsageCount,
          ),
          confirmButtonText: l10n.delete,
          onConfirm: () async {
            await symptomService.removeSymptom(symptom);
          },
        );
      },
    );
  }

  Future<void> _refreshSymptoms(BuildContext context, SymptomService symptomService) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_resetSymptomsList,
          contentText: l10n.settingsScreen_resetSymptomsListDescription,
          confirmButtonText: l10n.reset,
          onConfirm: () async {
            await symptomService.resetSymptoms();
          },
        );
      },
    );
  }

  Future<void> _selectLoggingReminderTime(BuildContext context, SettingsService settingsService) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: settingsService.periodOverdueNotificationTime,
    );

    if (pickedTime != null && pickedTime != settingsService.periodOverdueNotificationTime) {
      await settingsService.setLoggingReminderTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final symptomService = context.watch<SymptomService>();
    final settingsService = context.watch<SettingsService>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_LoggingScreen),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.settingsScreen_enableLoggingReminders),
            subtitle: Text(l10n.settingsScreen_loggingReminderDescription),
            value: settingsService.isLoggingReminderNotificationEnabled,
            onChanged: (bool value) {
              settingsService.setLoggingReminder(value);
            },
          ),
          if (settingsService.isLoggingReminderNotificationEnabled) ...[
            ListTile(
              title: Text(l10n.settingsScreen_loggingReminderTime),
              trailing: Text(
                settingsService.loggingReminderTime.format(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _selectLoggingReminderTime(context, settingsService),
            ),
          ],
          const Divider(),
          ListTile(
            title: Text(l10n.settingsScreen_defaultSymptoms),
            leading: Icon(
              Icons.bubble_chart_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          ListTile(
            subtitle: Text(l10n.settingsScreen_defaultSymptomsSubtitle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 4.0,
              runSpacing: 4.0,
              children: [
                ...symptomService.symptoms.map((symptom) {
                  return RawChip(
                    label: Text(symptom.getDisplayName(l10n)),
                    tapEnabled: true,
                    onPressed: () => _removeDefaultSymptom(context, symptom, l10n, symptomService),
                  );
                }),
                
                ActionChip(
                  avatar: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.reset), 
                  backgroundColor: colorScheme.secondaryContainer,
                  onPressed: () => _refreshSymptoms(context, symptomService),
                ),

                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(l10n.add),
                  backgroundColor: colorScheme.secondaryContainer,
                  onPressed: () => _showNewCustomSymptomDialog(context, symptomService),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}