import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';

import '../../widgets/dialogs/custom_symptom_dialog.dart';
import '../../widgets/dialogs/delete_confirmation_dialog.dart';

class PeriodSettingsScreen extends StatefulWidget {
  const PeriodSettingsScreen({super.key});

  @override
  State<PeriodSettingsScreen> createState() => _PeriodSettingsScreenState();
}

class _PeriodSettingsScreenState extends State<PeriodSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final periodsRepo = PeriodsRepository();

  bool _isLoading = true;

  Set<String> _defaultSymptoms = {};

  bool _periodNotificationsEnabled = true;
  int _periodNotificationDays = 1;
  TimeOfDay _periodNotificationTime = const TimeOfDay(hour: 9, minute: 0);

  bool _periodOverdueNotificationsEnabled = true;
  int _periodOverdueNotificationDays = 1;
  TimeOfDay _periodOverdueNotificationTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final periodNotificationsEnabled = await _settingsService.areNotificationsEnabled();
    final periodNotificationDays = await _settingsService.getNotificationDays();
    final periodNotificationTime = await _settingsService.getNotificationTime();
    final periodOverdueNotificationsEnabled = await _settingsService.arePeriodOverdueNotificationsEnabled();
    final periodOverdueNotificationDays = await _settingsService.getPeriodOverdueNotificationDays();
    final periodOverdueNotificationTime = await _settingsService.getPeriodOverdueNotificationTime();
    final defaultSymptoms = await _settingsService.getDefaultSymptoms();
    defaultSymptoms.add("+");

    if (mounted) {
      setState(() {
        _periodNotificationsEnabled = periodNotificationsEnabled;
        _periodNotificationDays = periodNotificationDays;
        _periodNotificationTime = periodNotificationTime;
        _periodOverdueNotificationsEnabled = periodOverdueNotificationsEnabled;
        _periodOverdueNotificationDays = periodOverdueNotificationDays;
        _periodOverdueNotificationTime = periodOverdueNotificationTime;
        _defaultSymptoms = defaultSymptoms;
        _isLoading = false;
      });
    }
  }

  Future<void> selectPeriodReminderTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: _periodNotificationTime);

    if (pickedTime != null && pickedTime != _periodNotificationTime) {
      setState(() {
        _periodNotificationTime = pickedTime;
      });
      await _settingsService.setNotificationTime(pickedTime);
    }
  }

  Future<void> selectOverduePeriodReminderTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: _periodOverdueNotificationTime);

    if (pickedTime != null && pickedTime != _periodOverdueNotificationTime) {
      setState(() {
        _periodOverdueNotificationTime = pickedTime;
      });
      await _settingsService.setPeriodOverdueNotificationTime(pickedTime);
    }
  }

  Future<void> _showNewCustomSymptomDialog() async {
    final (String name, bool isDefault)? result = await showDialog<(String, bool)>(
      context: context,
      builder: (BuildContext context) {
        return const CustomSymptomDialog(showMakeDefaultButton: false);
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

    var description = "'$symptom' will no longer be available when logging a period.\n\n";

    if (symptomUsageCount == 0) {
      description += "There are currently no period logs with this symptom!";
    }
    else if (symptomUsageCount == 1) {
      description += "There is already $symptomUsageCount period log with this symptom!\nThis log will not be changed.";
    } else if (symptomUsageCount > 1) {
      description += "There are $symptomUsageCount period logs with this symptom!\nThese logs will not be changed.";
    }

    if (mounted) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: "Delete '$symptom'?",
            contentText: description,
            confirmButtonText: symptomUsageCount > 0 ? "Delete anyways" : l10n.delete,
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
                  title: Text("Default symptoms"),
                  leading: Icon(Icons.bubble_chart_outlined, color: colorScheme.onSurfaceVariant, size: 20),
                ),
                ListTile(subtitle: Text("These are always available when logging new periods.\nTap an existing symptom to delete or '+' to add a new one.")),
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
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.settingsScreen_upcomingPeriodReminder),
                  value: _periodNotificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _periodNotificationsEnabled = value;
                    });
                    _settingsService.setNotificationsEnabled(value);
                  },
                ),
                if (_periodNotificationsEnabled) ...[
                  ListTile(
                    title: Text(l10n.settingsScreen_remindMeBefore),
                    trailing: DropdownButton<int>(
                      value: _periodNotificationDays,
                      items: [1, 2, 3].map((int days) {
                        return DropdownMenuItem<int>(value: days, child: Text(l10n.dayCount(days)));
                      }).toList(),
                      onChanged: (int? newDays) {
                        if (newDays != null) {
                          setState(() {
                            _periodNotificationDays = newDays;
                          });
                          _settingsService.setNotificationDays(newDays);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(l10n.settingsScreen_notificationTime),
                    trailing: Text(_periodNotificationTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onTap: selectPeriodReminderTime,
                  ),
                ],
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.settingsScreen_overduePeriodReminder),
                  value: _periodOverdueNotificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _periodOverdueNotificationsEnabled = value;
                    });
                    _settingsService.setPeriodOverdueNotificationsEnabled(value);
                  },
                ),
                if (_periodOverdueNotificationsEnabled) ...[
                  ListTile(
                    title: Text(l10n.settingsScreen_remindMeAfter),
                    trailing: DropdownButton<int>(
                      value: _periodOverdueNotificationDays,
                      items: [1, 2, 3].map((int days) {
                        return DropdownMenuItem<int>(value: days, child: Text(l10n.dayCount(days)));
                      }).toList(),
                      onChanged: (int? newDays) {
                        if (newDays != null) {
                          setState(() {
                            _periodOverdueNotificationDays = newDays;
                          });
                          _settingsService.setPeriodOverdueNotificationDays(newDays);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(l10n.settingsScreen_notificationTime),
                    trailing: Text(_periodOverdueNotificationTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onTap: selectOverduePeriodReminderTime,
                  ),
                ],
              ],
            ),
    );
  }
}
