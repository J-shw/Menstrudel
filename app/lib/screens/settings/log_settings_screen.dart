import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class LogSettingsScreen extends StatelessWidget {
  LogSettingsScreen({super.key});

  final periodsRepo = PeriodsRepository();

  Future<void> _showNewCustomSymptomDialog(BuildContext context) async {
    final settingsService = context.read<SettingsService>();
    
    final (String name, bool isDefault)? result =
        await showDialog<(String, bool)>(
          context: context,
          builder: (BuildContext context) {
            return const CustomSymptomDialog(hideTemporarySwitch: true);
          },
        );

    if (result != null) {
      var symptom = Symptom.fromDbString(result.$1);
      
      if (settingsService.defaultSymptoms.contains(symptom)) {
        return;
      }
      
      await settingsService.addDefaultSymptom(symptom);
    }
  }

  Future<void> _removeDefaultSymptom(BuildContext context, Symptom symptom) async {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.read<SettingsService>();
    final symptomUsageCount = await periodsRepo.getSingleSymptomFrequency(
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
            await settingsService.removeDefaultSymptom(symptom);
          },
        );
      },
    );
  }

  Future<void> _refreshSymptoms(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.read<SettingsService>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_resetSymptomsList,
          contentText: l10n.settingsScreen_resetSymptomsListDescription,
          confirmButtonText: l10n.reset,
          onConfirm: () async {
            await settingsService.resetDefaultSymptoms();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_LoggingScreen),
      ),
      body: ListView(
        children: [
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
                ...settingsService.defaultSymptoms.map((symptom) {
                  return RawChip(
                    label: Text(symptom.getDisplayName(l10n)),
                    tapEnabled: true,
                    onPressed: () => _removeDefaultSymptom(context, symptom),
                  );
                }),
                
                ActionChip(
                  avatar: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.reset), 
                  backgroundColor: colorScheme.secondaryContainer,
                  onPressed: () => _refreshSymptoms(context),
                ),

                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(l10n.add),
                  backgroundColor: colorScheme.secondaryContainer,
                  onPressed: () => _showNewCustomSymptomDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}