import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/l10n/l10n.dart';
import 'package:menstrudel/notifiers/locale_notifier.dart';
import 'package:provider/provider.dart';

class PreferencesSettingsScreen extends StatefulWidget {
  const PreferencesSettingsScreen({super.key});

  @override
  State<PreferencesSettingsScreen> createState() =>
      _PreferencesSettingsScreenState();
}

class _PreferencesSettingsScreenState extends State<PreferencesSettingsScreen> {
  final SettingsService _settingsService = SettingsService();

  bool _isLoading = true;
  bool _isPersistentReminderEnabled = false;
  String _selectedLanguage = 'system';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final (isEnabled, languageCode) = await (
      _settingsService.areAlwaysShowReminderButtonEnabled(),
      _settingsService.getLanguageCode(),
    ).wait;

    if (mounted) {
      setState(() {
        _isPersistentReminderEnabled = isEnabled;
        _selectedLanguage = languageCode;
        _isLoading = false;
      });
    }
  }

  Future<void> _onToggleChanged(bool value) async {
    setState(() {
      _isPersistentReminderEnabled = value;
    });
    await _settingsService.setAlwaysShowReminderButtonEnabled(value);
  }

  Future<void> _onLanguageChanged(String? newLanguageCode) async {
    if (newLanguageCode == null || newLanguageCode == _selectedLanguage) return;

    setState(() {
      _selectedLanguage = newLanguageCode;
    });

    Provider.of<LocaleNotifier>(context, listen: false).setLocale(newLanguageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageOptions = L10n.getLanguageOptions(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_preferences),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.preferencesScreen_language),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: languageOptions.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: _onLanguageChanged,
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.preferencesScreen_tamponReminderButton),
                  subtitle:
                      Text(l10n.preferencesScreen_tamponReminderButtonSubtitle),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  value: _isPersistentReminderEnabled,
                  onChanged: _onToggleChanged,
                ),
              ],
            ),
    );
  }
}