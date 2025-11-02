import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';
import 'package:menstrudel/notifiers/theme_notifier.dart';
import 'package:menstrudel/services/settings_service.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  Future<void> _showViewPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.read<SettingsService>();
    
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
              groupValue: settingsService.historyView, 
              onChanged: (PeriodHistoryView? value) {
                Navigator.of(context).pop(value);
              },
            );
          }).toList(),
        );
      },
    );

    if (result != null && result != settingsService.historyView) {
      await settingsService.setHistoryView(result);
    }
  }

  Future<void> _showThemeModePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = context.read<ThemeNotifier>();
    
    final AppThemeMode? result = await showDialog<AppThemeMode>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(l10n.settingsScreen_appTheme),
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(mode.getDisplayName(l10n)),
              value: mode,
              groupValue: themeNotifier.themeMode,
              onChanged: (AppThemeMode? value) => Navigator.of(context).pop(value),
            );
          }).toList(),
        );
      },
    );

    if (result != null && result != themeNotifier.themeMode) {
      themeNotifier.setThemeMode(result);
    }
  }

  void _showColorPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = context.read<ThemeNotifier>();
  
    Color pickerColor = themeNotifier.themeColor; 

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.settingsScreen_pickAColor),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (Color color) {
                    setDialogState(() => pickerColor = color);
                  },
                  pickerAreaHeightPercent: 0.8,
                );
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(l10n.select),
              onPressed: () {
                themeNotifier.setColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = context.watch<ThemeNotifier>();
    final settingsService = context.watch<SettingsService>();

    final selectedViewName = '${settingsService.historyView.name[0].toUpperCase()}${settingsService.historyView.name.substring(1)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_appearance),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.settingsScreen_historyViewStyle),
            subtitle: Text('$selectedViewName ${l10n.settingsScreen_view}'),
            onTap: () => _showViewPicker(context),
          ),
          ListTile(
            title: Text(l10n.settingsScreen_appTheme),
            subtitle: Text(themeNotifier.themeMode.getDisplayName(l10n)),
            onTap: () => _showThemeModePicker(context),
          ),
          SwitchListTile(
            title: Text(l10n.settingsScreen_dynamicTheme),
            subtitle: Text(l10n.settingsScreen_useWallpaperColors),
            value: themeNotifier.isDynamicEnabled,
            onChanged: (bool value) {
              context.read<ThemeNotifier>().setDynamicThemeEnabled(value);
            },
          ),
          if (!themeNotifier.isDynamicEnabled)
            ListTile(
              title: Text(l10n.settingsScreen_themeColor),
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: themeNotifier.themeColor,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () => _showColorPicker(context),
            ),
        ],
      ),
    );
  }
}