import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class PeriodLogSettingsScreen extends StatelessWidget {
  PeriodLogSettingsScreen({super.key});

  final periodsRepo = PeriodsRepository();

  Future<void> _showNewCustomSymptomDialog(BuildContext context) async {
    final settingsService = context.read<SettingsService>();
    
    final (String name, bool isDefault)? result =
        await showDialog<(String, bool)>(
          context: context,
          builder: (BuildContext context) {
            return const CustomSymptomDialog(showTemporarySymptomButton: true);
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
          confirmButtonText: symptomUsageCount > 0
              ? l10n.deleteAnyways
              : l10n.delete,
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
          title: l10n.settingsScreen_resetDefaultSymptoms,
          contentText: l10n.settingsScreen_resetDefaultSymptomsDescription,
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
        title: Text(l10n.settingsScreen_periodPredictionAndReminders),
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
                
                RawChip(
                  label: Text("↻"),
                  backgroundColor: colorScheme.onSecondary,
                  tapEnabled: true,
                  onPressed: () => _refreshSymptoms(context),
                ),
                RawChip(
                  label: Text("+"), 
                  backgroundColor: colorScheme.onSecondary,
                  tapEnabled: true,
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