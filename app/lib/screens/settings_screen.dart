import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/navigation_bar.dart';
import 'package:menstrudel/widgets/app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        titleText: "Settings",
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
              trailing: Text(_notificationTime.format(context)),
              onTap: _selectTime,
            ),
          ],
        ],
      ),
      bottomNavigationBar: MainBottomNavigationBar(isSettingScreenActive: true),
    );
  }
}