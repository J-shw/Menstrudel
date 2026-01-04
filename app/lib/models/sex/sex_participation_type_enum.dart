import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different levels of sexual participation types.
enum SexParticipationTypes {
  solo('solo'),
  partner('partner'),
  group('group'),
  other('other');

  /// The string identifier used for database storage.
  final String dbName;

  const SexParticipationTypes(this.dbName);

  /// Converts a database string back into a [SexParticipationTypes].
  static SexParticipationTypes fromDbName(String value) {
    return SexParticipationTypes.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => SexParticipationTypes.other,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      SexParticipationTypes.solo => l10n.sexParticipation_solo,
      SexParticipationTypes.partner => l10n.sexParticipation_partner,
      SexParticipationTypes.group => l10n.sexParticipation_group,
      SexParticipationTypes.other => l10n.other,
    };
  }

  IconData get icon {
    return switch (this) {
      SexParticipationTypes.solo => Icons.person,
      SexParticipationTypes.partner => Icons.people,
      SexParticipationTypes.group => Icons.group_add_rounded,
      SexParticipationTypes.other => Icons.extension,
    };
  }
}