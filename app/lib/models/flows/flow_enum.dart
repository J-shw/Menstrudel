import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

enum FlowRate {
  none,
  spotting,
  light,
  medium,
  heavy;

  /// Returns flow rates that represent an actual flow during a period.
  static List<FlowRate> get periodFlows  =>
    values.where((flow) => flow != FlowRate.none).toList();
}

extension FlowExtension on FlowRate {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case FlowRate.none:
        return l10n.flowIntensity_none;
      case FlowRate.spotting:
        return l10n.flowIntensity_spotting;
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
      case FlowRate.spotting:
        return Colors.pink.shade100;
      case FlowRate.light:
        return Colors.pink.shade200;
      case FlowRate.medium:
        return Colors.pink.shade400;
      case FlowRate.heavy:
        return Colors.red.shade600;
    }
  }
}