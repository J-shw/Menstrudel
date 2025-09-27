import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

import 'package:menstrudel/screens/settings/appearance_settings_screen.dart';
import 'package:menstrudel/screens/settings/birth_control_settings_screen.dart';
import 'package:menstrudel/screens/settings/period_settings_screen.dart';
import 'package:menstrudel/screens/settings/data_settings_screen.dart';
import 'package:menstrudel/screens/settings/security_settings_screen.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListView(
      children: [
        _SettingsSectionButton(
          title: l10n.settingsScreen_appearance,
          icon: Icons.palette_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppearanceSettingsScreen()),
            );
          },
        ),
        _SettingsSectionButton(
          title: l10n.settingsScreen_security,
          icon: Icons.security_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
            );
          },
        ),
        _SettingsSectionButton(
          title: l10n.settingsScreen_birthControl,
          icon: Icons.medical_information,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BirthControlSettingsScreen()),
            );
          },
        ),
        _SettingsSectionButton(
          title: l10n.settingsScreen_periodPredictionAndReminders,
          icon: Icons.water_drop_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PeriodSettingsScreen()),
            );
          },
        ),
        _SettingsSectionButton(
          title: l10n.settingsScreen_dataManagement,
          icon: Icons.storage_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DataSettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _SettingsSectionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsSectionButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}