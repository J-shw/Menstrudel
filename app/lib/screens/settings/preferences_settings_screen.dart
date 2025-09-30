import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class PreferencesSettingsScreen extends StatefulWidget {
  const PreferencesSettingsScreen({super.key});

  @override
  State<PreferencesSettingsScreen> createState() => _PreferencesSettingsScreenState();
}

class _PreferencesSettingsScreenState extends State<PreferencesSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  
  bool _isLoading = true;
  bool _isPersistentReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isEnabled = await _settingsService.areAlwaysShowReminderButtonEnabled(); 

    if (mounted) {
      setState(() {
        _isPersistentReminderEnabled = isEnabled;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_preferences),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: Text(l10n.preferencesScreen_tamponReminderButton),
                  subtitle: Text(l10n.preferencesScreen_tamponReminderButtonSubtitle),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  value: _isPersistentReminderEnabled,
                  onChanged: _onToggleChanged,
                ),
              ],
            ),
    );
  }
}