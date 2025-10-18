import 'package:menstrudel/l10n/app_localizations.dart';

/// This class is a custom helper to build language selection dropdown.
class L10n {
  static final Map<String, String> nativeLanguageNames = {
    'en': 'English',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
  };

static Map<String, String> getLanguageOptions(AppLocalizations l10n) {
    return {
      'system': l10n.systemDefault,
      ...nativeLanguageNames, 
    };
  }
}