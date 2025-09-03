import 'package:menstrudel/l10n/app_localizations.dart';

enum FlowRate {
  light,
  medium,
  heavy,
}

extension FlowExtension on FlowRate {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {

      case FlowRate.light:
        return l10n.flowIntensity_light;
      case FlowRate.medium:
        return l10n.flowIntensity_moderate;
      case FlowRate.heavy:
        return l10n.flowIntensity_heavy;
    }
  }
  int get intValue {
    return index;
  }
}