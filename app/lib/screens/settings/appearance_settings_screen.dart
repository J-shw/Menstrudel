import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';
import 'package:menstrudel/notifiers/theme_notifier.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/utils/constants.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  State<AppearanceSettingsScreen> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  bool _isLoading = true;
  
  PeriodHistoryView _selectedView = PeriodHistoryView.journal;
  Color _themeColor = seedColor;
  AppThemeMode _themeMode = AppThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final selectedView = await _settingsService.getHistoryView();
    final themeColor = await _settingsService.getThemeColor();
    final themeMode = await _settingsService.getThemeMode();
    
    if (mounted) {
      setState(() {
        _selectedView = selectedView;
        _themeColor = themeColor;
        _themeMode = themeMode;
        _isLoading = false;
      });
    }
  }

  Future<void> showViewPicker() async {
    final l10n = AppLocalizations.of(context)!;
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

  Future<void> _showThemeModePicker() async {
    final l10n = AppLocalizations.of(context)!;
    final AppThemeMode? result = await showDialog<AppThemeMode>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(l10n.settingsScreen_appTheme),
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(mode.getDisplayName(l10n)),
              value: mode,
              groupValue: _themeMode,
              onChanged: (AppThemeMode? value) => Navigator.of(context).pop(value),
            );
          }).toList(),
        );
      },
    );

    if (result != null && result != _themeMode) {
      setState(() => _themeMode = result);
      if (mounted){
        context.read<ThemeNotifier>().setThemeMode(result);
      }
    }
  }

  void _showColorPicker() {
     final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.settingsScreen_pickAColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _themeColor,
              onColorChanged: (Color color) => setState(() => _themeColor = color),
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(l10n.select),
              onPressed: () {
                context.read<ThemeNotifier>().setColor(_themeColor);
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
    final selectedViewName = '${_selectedView.name[0].toUpperCase()}${_selectedView.name.substring(1)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_appearance),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text(l10n.settingsScreen_historyViewStyle),
                  subtitle: Text('$selectedViewName ${l10n.settingsScreen_view}'),
                  onTap: showViewPicker,
                ),
                ListTile(
                  title: Text(l10n.settingsScreen_appTheme),
                  subtitle: Text(_themeMode.getDisplayName(l10n)),
                  onTap: _showThemeModePicker,
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
                        color: _themeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    onTap: _showColorPicker,
                  ),
              ],
            ),
    );
  }
}