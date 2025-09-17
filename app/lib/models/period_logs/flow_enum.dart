import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

enum FlowRate {
  none,
  light,
  medium,
  heavy,
}

extension FlowExtension on FlowRate {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case FlowRate.none:
        return l10n.flowIntensity_none;
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
  Color get color {
    switch (this) {
      case FlowRate.none:
        return Colors.blue.shade300;
      case FlowRate.light:
        return Colors.pink.shade200;
      case FlowRate.medium:
        return Colors.pink.shade400;
      case FlowRate.heavy:
        return Colors.red.shade700;
    }
  }
}