import 'package:flutter/material.dart';
import 'package:menstrudel/models/prefrences/day_of_week_enum.dart';
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
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: Text(l10n.preferencesScreen_StartingDayOfWeek),
            trailing: DropdownButton<String>(
              value: settingsService.startingDayOfWeek,
              items: DayOfWeek.values.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.getDisplayName(l10n)),
                );
              }).toList(),
              onChanged: (String? newStartingDayOfWeek) {
                if (newStartingDayOfWeek != null) {
                  context.read<SettingsService>().setStartingDayOfWeek(newStartingDayOfWeek);
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text(l10n.preferencesScreen_enableSanitaryProductsScreen),
            subtitle:
                Text(l10n.preferencesScreen_enableSanitaryProductsScreenSubtitle),
            secondary: const Icon(Icons.water_drop_outlined),
            value: settingsService.isSanitaryNavEnabled,
            onChanged: (bool value) {
              context.read<SettingsService>().setSanitaryNavEnabled(value);
            },
          ),
          SwitchListTile(
            title: Text(l10n.preferencesScreen_enableSexActivityScreen),
            subtitle:
                Text(l10n.preferencesScreen_enableSexActivityScreenSubtitle),
            secondary: const Icon(Icons.favorite_border_rounded),
            value: settingsService.isSexActivityNavEnabled,
            onChanged: (bool value) {
              context.read<SettingsService>().setSexActivityNavEnabled(value);
            },
          ),
        ],
      ),
    );
  }
}