import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/utils/constants.dart';

class ThemeNotifier with ChangeNotifier {
  late Color _themeColor;
  late bool _isDynamicEnabled;
  final SettingsService _settingsService = SettingsService();


   ThemeNotifier() {
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
  
  Future<void> loadTheme() async {
    _themeColor = await _settingsService.getThemeColor();
    notifyListeners();
  }

  Future<void> loadAllThemeSettings() async {
    _themeColor = await _settingsService.getThemeColor();
    _isDynamicEnabled = await _settingsService.isDynamicThemeEnabled();
    notifyListeners();
  }
}