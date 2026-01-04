import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different levels of sexual participation types.
enum SexParticipationType {
  solo('solo'),
  partner('partner'),
  group('group'),
  other('other');

  /// The string identifier used for database storage.
  final String dbName;

  const SexParticipationType(this.dbName);

  /// Converts a database string back into a [SexParticipationType].
  static SexParticipationType fromDbName(String value) {
    return SexParticipationType.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => SexParticipationType.other,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      SexParticipationType.solo => l10n.sexParticipation_solo,
      SexParticipationType.partner => l10n.sexParticipation_partner,
      SexParticipationType.group => l10n.sexParticipation_group,
      SexParticipationType.other => l10n.other,
    };
  }

  IconData get icon {
    return switch (this) {
      SexParticipationType.solo => Icons.person,
      SexParticipationType.partner => Icons.people,
      SexParticipationType.group => Icons.group_add_rounded,
      SexParticipationType.other => Icons.extension,
    };
  }
}