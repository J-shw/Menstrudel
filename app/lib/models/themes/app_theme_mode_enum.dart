import 'package:menstrudel/l10n/app_localizations.dart';

enum AppThemeMode { light, dark, system }

extension AppthememodeExtension on AppThemeMode {
  
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case AppThemeMode.light:
        return l10n.settingsScreen_themeLight;
      case AppThemeMode.dark:
        return l10n.settingsScreen_themeDark;
      case AppThemeMode.system:
        return l10n.settingsScreen_themeSystem;
    }
  }
}