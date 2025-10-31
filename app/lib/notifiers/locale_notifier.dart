import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';

class LocaleNotifier extends ChangeNotifier {
  final SettingsService _settingsService;
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleNotifier(this._settingsService) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = _settingsService.languageCode;
    
    if (languageCode == 'system') {
      _locale = null;
    } else {
      _locale = Locale(languageCode);
    }
  }

  /// Saves the new language code and notifies listeners to rebuild the app.
  Future<void> setLocale(String languageCode) async {
    if (languageCode == 'system') {
      _locale = null;
    } else {
      _locale = Locale(languageCode);
    }
    
    await _settingsService.setLanguageCode(languageCode);
    
    notifyListeners();
  }
}