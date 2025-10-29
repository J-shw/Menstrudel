import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';

class ThemeNotifier with ChangeNotifier {
  late Color _themeColor;
  late bool _isDynamicEnabled;
  final SettingsService _settingsService;
  AppThemeMode _themeMode = AppThemeMode.system;
  AppThemeMode get themeMode => _themeMode;

  ThemeNotifier(this._settingsService) {
    _themeColor = seedColor;
    _isDynamicEnabled = false;
    loadAllThemeSettings();
  }

  Color get themeColor => _themeColor;
  bool get isDynamicEnabled => _isDynamicEnabled;

  Future<void> setColor(Color color) async {
    _themeColor = color;
    await _settingsService.setThemeColor(color);
    notifyListeners();
  }

  Future<void> setDynamicThemeEnabled(bool isEnabled) async {
    _isDynamicEnabled = isEnabled;
    await _settingsService.setDynamicColorEnabled(isEnabled);
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _settingsService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> loadAllThemeSettings() async {
    _themeColor = _settingsService.themeColor;
    _isDynamicEnabled = _settingsService.isDynamicThemeEnabled;
    _themeMode = _settingsService.themeMode;
    notifyListeners();
  }
}