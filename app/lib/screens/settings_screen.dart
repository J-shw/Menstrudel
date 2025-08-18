import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/models/pills/pill_reminder.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/widgets/settings/regimen_setup_dialog.dart';
import 'package:menstrudel/services/notification_service.dart';

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
    final PeriodHistoryView? result = await showDialog<PeriodHistoryView>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select History View'),
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
    await pillsRepo.savePillReminder(reminder);

    await NotificationService.schedulePillReminder(
      reminderTime: _pillNotificationTime,
      isEnabled: _pillNotificationsEnabled,
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
    if (_activeRegimen == null) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Delete Regimen?',
          content: const Text(
            'This will delete your current pill pack settings and all associated pill logs. This cannot be undone.',
          ),
          confirmButtonText: 'Delete',
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
    setState(() {
      _isLoading = true;
    });

    await periodsRepo.deleteAllEntries();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All logs have been cleared.')),
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> showClearLogsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Clear All Logs?',
          content: const Text(
            'This will permanently delete all your period logs. Your app settings will not be affected.',
          ),
          confirmButtonText: 'Clear',
          onConfirm: clearLogs,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedViewName = '${_selectedView.name[0].toUpperCase()}${_selectedView.name.substring(1)}';

    return ListView(
      children: [
        const ListTile(
          title: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: const Text('History View Style'),
          subtitle: Text('$selectedViewName View'),
          onTap: showViewPicker,
        ),

        const Divider(),

        const ListTile(
          title: Text('Birth Control', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        if (_activeRegimen == null)
          ListTile(
            title: const Text('Set Up Pill Regimen'),
            subtitle: const Text('Track your daily pill intake.'),
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
            title: const Text('Daily Pill Reminder'),
            value: _pillNotificationsEnabled,
            onChanged: (bool value) {
              setState(() { _pillNotificationsEnabled = value; });
              savePillReminderSettings();
            },
          ),
          if (_pillNotificationsEnabled)
            ListTile(
              title: const Text('Reminder Time'),
              trailing: Text(
                _pillNotificationTime.format(context),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: selectPillReminderTime,
            ),
        ],
        const Divider(),
        const ListTile(
          title: Text('Period Predictions & Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SwitchListTile(
          title: const Text('Upcoming Period Reminders'),
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
            title: const Text('Remind Me Before'),
            trailing: DropdownButton<int>(
              value: _notificationDays,
              items: [1, 2, 3].map((int days) {
                return DropdownMenuItem<int>(
                  value: days,
                  child: Text('$days Day${days > 1 ? 's' : ''}'),
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
            title: const Text('Notification Time'),
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
            'Clear All Period Data',
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