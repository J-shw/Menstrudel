import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/utils/constants.dart';

class ThemeNotifier with ChangeNotifier {
  late Color _themeColor;
  final SettingsService _settingsService = SettingsService();

  ThemeNotifier() {
    _themeColor = seedColor;
    loadTheme();
  }

  Color get themeColor => _themeColor;

  Future<void> setColor(Color color) async {
    _themeColor = color;
    await _settingsService.setThemeColor(color);
    notifyListeners();
  }
  
  Future<void> loadTheme() async {
    _themeColor = await _settingsService.getThemeColor();
    notifyListeners();
  }
}