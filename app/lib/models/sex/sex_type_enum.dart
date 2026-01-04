import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different types of sex.
enum SexType {
  vaginal,
  anal,
  oral,
  /// Manual stimulation (e.g., handjob, fingering).
  manual,
  /// Other types of sexual activity not covered by the above.
  other,
}

extension SexTypeExtension on SexType {
  String getDbName() {
    switch (this) {
      case SexType.vaginal:
        return 'vaginal';
      case SexType.anal:
        return 'anal';
      case SexType.oral:
        return 'oral';
      case SexType.manual:
        return 'manual';
      case SexType.other:
        return 'other';
    }
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case SexType.vaginal:
        return l10n.sexType_vaginal;
      case SexType.anal:
        return l10n.sexType_anal;
      case SexType.oral:
        return l10n.sexType_oral;
      case SexType.manual:
        return l10n.sexType_manual;
      case SexType.other:
        return l10n.other;
    }
  }

  /// gets the associated icon
  /// I'm not sure these are the best icons but they will do for now...
  // TODO: revisit icon choices later
  IconData getIcon() {
    switch (this) {
      case SexType.vaginal:
        return Icons.favorite;
      case SexType.anal:
        return Icons.air;
      case SexType.oral:
        return Icons.auto_awesome;
      case SexType.manual:
        return Icons.front_hand;
      case SexType.other:
        return Icons.extension;
    }
  }
}