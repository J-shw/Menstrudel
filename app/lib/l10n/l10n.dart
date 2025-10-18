import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class L10n {
  static final all = {
    'en': 'English',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
  };

  static List<Locale> get supportedLocales {
    return all.keys.map((code) => Locale(code)).toList();
  }

  static Map<String, String> getLanguageOptions(AppLocalizations l10n) {
    return {
      'system': l10n.systemDefault,
      ...all,
    };
  }
}