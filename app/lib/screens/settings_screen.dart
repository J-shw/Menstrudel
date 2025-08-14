import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/main/navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/database/period_database.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();

  bool _isLoading = true;
  bool _notificationsEnabled = true;
  int _notificationDays = 1;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _notificationsEnabled = await _settingsService.areNotificationsEnabled();
    _notificationDays = await _settingsService.getNotificationDays();
    _notificationTime = await _settingsService.getNotificationTime();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectTime() async {
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

  Future<void> _showClearLogsDialog() async {
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
          onConfirm: _clearLogs,
        );
      },
    );
  }

  Future<void> _clearLogs() async {
    setState(() {
      _isLoading = true;
    });

    await PeriodDatabase.instance.deleteAllEntries();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All logs have been cleared.')),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
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
            onTap: _selectTime,
          ),
        ],
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.playlist_remove,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Clear Logs',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          onTap: _showClearLogsDialog,
        ),
      ],
    );
  }
}