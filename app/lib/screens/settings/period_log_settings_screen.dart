import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';

class PeriodLogSettingsScreen extends StatefulWidget {
  const PeriodLogSettingsScreen({super.key});

  @override
  State<PeriodLogSettingsScreen> createState() => _PeriodLogSettingsScreenState();
}

class _PeriodLogSettingsScreenState extends State<PeriodLogSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final periodsRepo = PeriodsRepository();

  bool _isLoading = true;

  Set<String> _defaultSymptoms = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final defaultSymptoms = await _settingsService.getDefaultSymptoms();
    defaultSymptoms.add("+");

    if (mounted) {
      setState(() {
        _defaultSymptoms = defaultSymptoms;
        _isLoading = false;
      });
    }
  }

  Future<void> _showNewCustomSymptomDialog() async {
    final (String name, bool isDefault)? result = await showDialog<(String, bool)>(
      context: context,
      builder: (BuildContext context) {
        return const CustomSymptomDialog(showTemporarySymptomButton: true);
      },
    );

    if (result != null && mounted) {
      var customSymptomName = result.$1;

      await _settingsService.addDefaultSymptom(customSymptomName);

      setState(() {
        _defaultSymptoms.remove("+");
        _defaultSymptoms.add(customSymptomName);
        _defaultSymptoms.add("+");
      });
    }
  }

  Future<void> _removeDefaultSymptom(String symptom) async {
    final l10n = AppLocalizations.of(context)!;
    final symptomUsageCount = await periodsRepo.getSymptomUseCount(symptom);

    if (mounted) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: l10n.settingsScreen_deleteDefaultSymptomQuestion(symptom),
            contentText: l10n.settingsScreen_deleteDefaultSymptomDescription(symptom, symptomUsageCount),
            confirmButtonText: symptomUsageCount > 0 ? l10n.deleteAnyways : l10n.delete,
            onConfirm: () async {
              setState(() {
                _defaultSymptoms.remove(symptom);
              });
              await _settingsService.removeDefaultSymptom(symptom);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsScreen_periodPredictionAndReminders)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text(l10n.settingsScreen_defaultSymptoms),
                  leading: Icon(Icons.bubble_chart_outlined, color: colorScheme.onSurfaceVariant, size: 20),
                ),
                ListTile(subtitle: Text(l10n.settingsScreen_defaultSymptomsSubtitle)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: _defaultSymptoms.map((symptom) {
                      var isAdd = symptom == "+";
                      return RawChip(label: Text(symptom), backgroundColor: isAdd ? colorScheme.onSecondary : null, tapEnabled: true, onPressed: () => {if (isAdd) _showNewCustomSymptomDialog() else _removeDefaultSymptom(symptom)});
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
