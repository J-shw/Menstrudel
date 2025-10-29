import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/custom_symptom_dialog.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';

class PeriodLogSettingsScreen extends StatefulWidget {
  const PeriodLogSettingsScreen({super.key});

  @override
  State<PeriodLogSettingsScreen> createState() =>
      _PeriodLogSettingsScreenState();
}

class _PeriodLogSettingsScreenState extends State<PeriodLogSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final periodsRepo = PeriodsRepository();

  bool _isLoading = true;

  final Set<Symptom> _defaultSymptoms = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isLoading = true;

    var defaultSymptoms = await _settingsService.getDefaultSymptoms();
    defaultSymptoms.add(Symptom.addSymptom());
    defaultSymptoms.add(Symptom.refreshSymptom());

    if (mounted) {
      setState(() {
        _defaultSymptoms.clear();
        _defaultSymptoms.addAll(defaultSymptoms);
      });
    }

    _isLoading = false;
  }

  Future<void> _showNewCustomSymptomDialog() async {
    final (String name, bool isDefault)? result =
        await showDialog<(String, bool)>(
          context: context,
          builder: (BuildContext context) {
            return const CustomSymptomDialog(showTemporarySymptomButton: true);
          },
        );

    if (mounted &&
        result != null &&
        _defaultSymptoms.any((element) => element.customName == result.$1) ==
            false) {
      var symptom = Symptom.fromDbString(result.$1);

      await _settingsService.addDefaultSymptom(symptom);
      await _loadSettings();
    }
  }

  Future<void> _removeDefaultSymptom(Symptom symptom) async {
    final l10n = AppLocalizations.of(context)!;
    final symptomUsageCount = await periodsRepo.getSingleSymptomFrequency(
      symptom,
    );

    if (mounted) {
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

  Future<void> _refreshSymptoms() async {
    final l10n = AppLocalizations.of(context)!;

    if (mounted) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: l10n.settingsScreen_resetDefaultSymptoms,
            contentText: l10n.settingsScreen_resetDefaultSymptomsDescription,
            confirmButtonText: l10n.reset,
            onConfirm: () async {
              await _settingsService.resetDefaultSymptoms();
              await _loadSettings();
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
      appBar: AppBar(
        title: Text(l10n.settingsScreen_periodPredictionAndReminders),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: _defaultSymptoms.map((symptom) {
                      var isAdd = symptom == Symptom.addSymptom();
                      var isRefresh = symptom == Symptom.refreshSymptom();
                      return RawChip(
                        label: Text(symptom.getDisplayName(l10n)),
                        backgroundColor: isAdd || isRefresh
                            ? colorScheme.onSecondary
                            : null,
                        tapEnabled: true,
                        onPressed: () => {
                          if (isRefresh)
                            {_refreshSymptoms()}
                          else if (isAdd)
                            {_showNewCustomSymptomDialog()}
                          else
                            {_removeDefaultSymptom(symptom)},
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
