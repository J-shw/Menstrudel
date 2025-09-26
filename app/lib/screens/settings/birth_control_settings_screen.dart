import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/widgets/settings/regimen_setup_dialog.dart';

class BirthControlSettingsScreen extends StatefulWidget {
  const BirthControlSettingsScreen({super.key});

  @override
  State<BirthControlSettingsScreen> createState() =>
      _BirthControlSettingsScreenState();
}

class _BirthControlSettingsScreenState extends State<BirthControlSettingsScreen> {
  final pillsRepo = PillsRepository();
  bool _isLoading = true;

  PillRegimen? _activeRegimen;
  bool _pillNotificationsEnabled = false;
  TimeOfDay _pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final activeRegimen = await pillsRepo.readActivePillRegimen();
    PillReminder? pillReminder;
    bool pillNotificationsEnabled = false;
    TimeOfDay pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);

    if (activeRegimen != null) {
      pillReminder = await pillsRepo.readReminderForRegimen(activeRegimen.id!);
      if (pillReminder != null) {
        pillNotificationsEnabled = pillReminder.isEnabled;
        final timeParts = pillReminder.reminderTime.split(':');
        pillNotificationTime = TimeOfDay(
            hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
    }

    if (mounted) {
      setState(() {
        _activeRegimen = activeRegimen;
        _pillNotificationsEnabled = pillNotificationsEnabled;
        _pillNotificationTime = pillNotificationTime;
        _isLoading = false;
      });
    }
  }

  Future<void> savePillReminderSettings() async {
    if (_activeRegimen == null) return;

    final reminder = PillReminder(
      regimenId: _activeRegimen!.id!,
      reminderTime:
          '${_pillNotificationTime.hour}:${_pillNotificationTime.minute}',
      isEnabled: _pillNotificationsEnabled,
    );
    final l10n = AppLocalizations.of(context)!;

    await pillsRepo.savePillReminder(reminder);

    await NotificationService.schedulePillReminder(
      reminderTime: _pillNotificationTime,
      isEnabled: _pillNotificationsEnabled,
      title: l10n.notification_pillTitle,
      body: l10n.notification_pillBody,
    );

    _loadSettings();
  }

  Future<void> selectPillReminderTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _pillNotificationTime,
    );

    if (pickedTime != null && pickedTime != _pillNotificationTime) {
      setState(() {
        _pillNotificationTime = pickedTime;
      });
      await savePillReminderSettings();
    }
  }

  Future<void> showRegimenSetupDialog() async {
    final result = await showDialog<PillRegimen>(
      context: context,
      builder: (BuildContext context) {
        return const RegimenSetupDialog();
      },
    );

    if (result != null && mounted) {
      await pillsRepo.createPillRegimen(result);
      await NotificationService.cancelPillReminder();
      _loadSettings();
    }
  }

  Future<void> showDeleteRegimenDialog() async {
    final l10n = AppLocalizations.of(context)!;
    if (_activeRegimen == null) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_deleteRegimen_question,
          contentText: l10n.settingsScreen_deleteRegimenDescription,
          confirmButtonText: l10n.delete,
          onConfirm: () async {
            await pillsRepo.deletePillRegimen(_activeRegimen!.id!);
            await NotificationService.cancelPillReminder();
            _loadSettings();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_birthControl),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (_activeRegimen == null)
                  ListTile(
                    title: Text(l10n.settingsScreen_setUpPillRegimen),
                    subtitle: Text(l10n.settingsScreen_trackYourDailyPillIntake),
                    trailing: const Icon(Icons.add),
                    onTap: showRegimenSetupDialog,
                  )
                else ...[
                  ListTile(
                    title: Text(_activeRegimen!.name),
                    subtitle: Text(
                        '${_activeRegimen!.activePills}/${_activeRegimen!.placeboPills} Pack'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error),
                      onPressed: showDeleteRegimenDialog,
                    ),
                  ),
                  SwitchListTile(
                    title: Text(l10n.settingsScreen_dailyPillReminder),
                    value: _pillNotificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _pillNotificationsEnabled = value;
                      });
                      savePillReminderSettings();
                    },
                  ),
                  if (_pillNotificationsEnabled)
                    ListTile(
                      title: Text(l10n.settingsScreen_reminderTime),
                      trailing: Text(
                        _pillNotificationTime.format(context),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onTap: selectPillReminderTime,
                    ),
                ],
              ],
            ),
    );
  }
}