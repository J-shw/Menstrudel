import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/l10n/l10n.dart';
import 'package:menstrudel/notifiers/locale_notifier.dart';
import 'package:provider/provider.dart';

class PreferencesSettingsScreen extends StatelessWidget {
  const PreferencesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageOptions = L10n.getLanguageOptions(l10n);
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_preferences),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.preferencesScreen_language),
            trailing: DropdownButton<String>(
              value: settingsService.languageCode,
              items: languageOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (String? newLanguageCode) {
                if (newLanguageCode != null) {
                  context.read<LocaleNotifier>().setLocale(newLanguageCode);
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text(l10n.preferencesScreen_tamponReminderButton),
            subtitle:
                Text(l10n.preferencesScreen_tamponReminderButtonSubtitle),
            secondary: const Icon(Icons.notifications_active_outlined),
            value: settingsService.areAlwaysShowReminderButtonEnabled,
            onChanged: (bool value) {
              context.read<SettingsService>().setAlwaysShowReminderButtonEnabled(value);
            },
          ),
        ],
      ),
    );
  }
}