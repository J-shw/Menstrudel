import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';

class PeriodSettingsScreen extends StatelessWidget {
  const PeriodSettingsScreen({super.key});

  Future<void> _selectPeriodReminderTime(BuildContext context) async {
    final settingsService = context.read<SettingsService>();
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: settingsService.notificationTime,
    );

    if (pickedTime != null && pickedTime != settingsService.notificationTime) {
      await settingsService.setNotificationTime(pickedTime);
    }
  }

  Future<void> _selectOverduePeriodReminderTime(BuildContext context) async {
    final settingsService = context.read<SettingsService>();
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: settingsService.periodOverdueNotificationTime,
    );

    if (pickedTime != null && pickedTime != settingsService.periodOverdueNotificationTime) {
      await settingsService.setPeriodOverdueNotificationTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_periodPredictionAndReminders),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.settingsScreen_upcomingPeriodReminder),
            value: settingsService.areNotificationsEnabled,
            onChanged: (bool value) {
              context.read<SettingsService>().setNotificationsEnabled(value);
            },
          ),
          if (settingsService.areNotificationsEnabled) ...[
            ListTile(
              title: Text(l10n.settingsScreen_remindMeBefore),
              trailing: DropdownButton<int>(
                value: settingsService.notificationDays,
                items: [1, 2, 3].map((int days) {
                  return DropdownMenuItem<int>(
                    value: days,
                    child: Text(l10n.dayCount(days)),
                  );
                }).toList(),
                onChanged: (int? newDays) {
                  if (newDays != null) {
                    context.read<SettingsService>().setNotificationDays(newDays);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(l10n.settingsScreen_notificationTime),
              trailing: Text(
                settingsService.notificationTime.format(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _selectPeriodReminderTime(context),
            ),
          ],
          const Divider(),
          SwitchListTile(
            title: Text(l10n.settingsScreen_overduePeriodReminder),
            value: settingsService.arePeriodOverdueNotificationsEnabled,
            onChanged: (bool value) {
              context.read<SettingsService>().setPeriodOverdueNotificationsEnabled(value);
            },
          ),
          if (settingsService.arePeriodOverdueNotificationsEnabled) ...[
            ListTile(
              title: Text(l10n.settingsScreen_remindMeAfter),
              trailing: DropdownButton<int>(
                value: settingsService.periodOverdueNotificationDays,
                items: [1, 2, 3].map((int days) {
                  return DropdownMenuItem<int>(
                    value: days,
                    child: Text(l10n.dayCount(days)),
                  );
                }).toList(),
                onChanged: (int? newDays) {
                  if (newDays != null) {
                    context
                        .read<SettingsService>()
                        .setPeriodOverdueNotificationDays(newDays);
                  }
                },
              ),
            ),
            ListTile(
              title: Text(l10n.settingsScreen_notificationTime),
              trailing: Text(
                settingsService.periodOverdueNotificationTime.format(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _selectOverduePeriodReminderTime(context),
            ),
          ],
        ],
      ),
    );
  }
}