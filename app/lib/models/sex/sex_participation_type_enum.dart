import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different levels of sexual participation types.
enum SexParticipationType {
  solo,
  partner,
  group,
  other,
}

extension SexParticipationTypeExtension on SexParticipationType {
  String getDbName() {
    switch (this) {
      case SexParticipationType.solo:
        return 'solo';
      case SexParticipationType.partner:
        return 'partner';
      case SexParticipationType.group:
        return 'group';
      case SexParticipationType.other:
        return 'other';
    }
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case SexParticipationType.solo:
        return l10n.sexParticipation_solo;
      case SexParticipationType.partner:
        return l10n.sexParticipation_partner;
      case SexParticipationType.group:
        return l10n.sexParticipation_group;
      case SexParticipationType.other:
        return l10n.other;
    }
  }

  /// gets the associated icon
  IconData getIcon() {
    switch (this) {
      case SexParticipationType.solo:
        return Icons.person;
      case SexParticipationType.partner:
        return Icons.people;
      case SexParticipationType.group:
        return Icons.group_add_rounded;
      case SexParticipationType.other:
        return Icons.extension;
    }
  }
}