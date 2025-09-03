import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/widgets/settings/regimen_setup_dialog.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final periodsRepo = PeriodsRepository();
  final pillsRepo = PillsRepository();

  final SettingsService _settingsService = SettingsService();

  bool _isLoading = true;
  bool _notificationsEnabled = true;
  int _notificationDays = 1;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);

  PillRegimen? _activeRegimen;
  PillReminder? _pillReminder;
  bool _pillNotificationsEnabled = false;
  TimeOfDay _pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);
  PeriodHistoryView _selectedView = PeriodHistoryView.journal;


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() { _isLoading = true; });
    
    _notificationsEnabled = await _settingsService.areNotificationsEnabled();
    _notificationDays = await _settingsService.getNotificationDays();
    _notificationTime = await _settingsService.getNotificationTime();
    _selectedView = await _settingsService.getHistoryView();
    _activeRegimen = await pillsRepo.readActivePillRegimen();

    if (_activeRegimen != null) {
      _pillReminder = await pillsRepo.readReminderForRegimen(_activeRegimen!.id!);
      if (_pillReminder != null) {
        _pillNotificationsEnabled = _pillReminder!.isEnabled;
        final timeParts = _pillReminder!.reminderTime.split(':');
        _pillNotificationTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      } else {
        _pillNotificationsEnabled = false;
        _pillNotificationTime = const TimeOfDay(hour: 21, minute: 0);
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> showViewPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final PeriodHistoryView? result = await showDialog<PeriodHistoryView>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(l10n.settingsScreen_selectHistoryView),
          children: PeriodHistoryView.values.map((view) {
            final viewName = '${view.name[0].toUpperCase()}${view.name.substring(1)}';
            return RadioListTile<PeriodHistoryView>(
              title: Text('$viewName View'),
              value: view,
              groupValue: _selectedView,
              onChanged: (PeriodHistoryView? value) {
                Navigator.of(context).pop(value);
              },
            );
          }).toList(),
        );
      },
    );

    if (result != null && result != _selectedView) {
      setState(() => _selectedView = result);
      await _settingsService.setHistoryView(result);
    }
  }

  Future<void> savePillReminderSettings() async {
    if (_activeRegimen == null) return;
    
    final reminder = PillReminder(
      regimenId: _activeRegimen!.id!,
      reminderTime: '${_pillNotificationTime.hour}:${_pillNotificationTime.minute}',
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
      setState(() { _pillNotificationTime = pickedTime; });
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

      await pillsRepo.createPillRegimen(result);
      
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
          content: Text(
            l10n.settingsScreen_deleteRegimenDescription,
          ),
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

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );

    if (pickedTime != null && pickedTime != _notificationTime) {
      setState(() {
        _notificationTime = pickedTime;
      });
      await _settingsService.setNotificationTime(pickedTime);
    }
  }

  Future<void> clearLogs() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
    });

    await periodsRepo.deleteAllEntries();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsScreen_allLogsHaveBeenCleared)),
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> showClearLogsDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_clearAllLogs_question,
          content: Text(
            l10n.settingsScreen_deleteAllLogsDescription,
          ),
          confirmButtonText: l10n.clear,
          onConfirm: clearLogs,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedViewName = '${_selectedView.name[0].toUpperCase()}${_selectedView.name.substring(1)}';

    return ListView(
      children: [
        ListTile(
          title: Text(l10n.settingsScreen_appearance, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: Text(l10n.settingsScreen_historyViewStyle),
          subtitle: Text('$selectedViewName ${l10n.settingsScreen_view}'),
          onTap: showViewPicker,
        ),

        const Divider(),

        ListTile(
          title: Text(l10n.settingsScreen_birthControl, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
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
            subtitle: Text('${_activeRegimen!.activePills}/${_activeRegimen!.placeboPills} Pack'),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
              onPressed: showDeleteRegimenDialog,
            ),
          ),
          SwitchListTile(
            title: Text(l10n.settingsScreen_dailyPillReminder),
            value: _pillNotificationsEnabled,
            onChanged: (bool value) {
              setState(() { _pillNotificationsEnabled = value; });
              savePillReminderSettings();
            },
          ),
          if (_pillNotificationsEnabled)
            ListTile(
              title: Text(l10n.settingsScreen_reminderTime),
              trailing: Text(
                _pillNotificationTime.format(context),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: selectPillReminderTime,
            ),
        ],
        const Divider(),
        ListTile(
          title: Text(l10n.settingsScreen_periodPredictionAndReminders, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SwitchListTile(
          title: Text(l10n.settingsScreen_upcomingPeriodReminder),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
            _settingsService.setNotificationsEnabled(value);
          },
        ),
        if (_notificationsEnabled) ...[
          ListTile(
            title: Text(l10n.settingsScreen_remindMeBefore),
            trailing: DropdownButton<int>(
              value: _notificationDays,
              items: [1, 2, 3].map((int days) {
                return DropdownMenuItem<int>(
                  value: days,
                  child: Text(l10n.dayCount(days)),
                );
              }).toList(),
              onChanged: (int? newDays) {
                if (newDays != null) {
                  setState(() {
                    _notificationDays = newDays;
                  });
                  _settingsService.setNotificationDays(newDays);
                }
              },
            ),
          ),
          ListTile(
            title: Text(l10n.settingsScreen_notificationTime),
            trailing: Text(
              _notificationTime.format(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: selectTime,
          ),
        ],
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.playlist_remove,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            l10n.settingsScreen_clearAllLogs,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          onTap: showClearLogsDialog,
        ),
      ],
    );
  }
}