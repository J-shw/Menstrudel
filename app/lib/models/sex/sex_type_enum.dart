import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different types of sex.
enum SexType {
  vaginal('vaginal'),
  anal('anal'),
  oral('oral'),
  /// Manual stimulation (e.g., handjob, fingering).
  manual('manual'),
  /// Other types of sexual activity not covered by the above.
  other('other');

  /// The string identifier used for database storage.
  final String dbName;

  const SexType(this.dbName);

  /// Converts a database string back into a [SexType].
  static SexType fromDbName(String value) {
    return SexType.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => SexType.other,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      SexType.vaginal => l10n.sexType_vaginal,
      SexType.anal => l10n.sexType_anal,
      SexType.oral => l10n.sexType_oral,
      SexType.manual => l10n.sexType_manual,
      SexType.other => l10n.other,
    };
  }

  /// gets the associated icon
  /// I'm not sure these are the best icons but they will do for now...
  // TODO: revisit icon choices later
  IconData get icon {
    return switch (this) {
      SexType.vaginal => Icons.favorite,
      SexType.anal => Icons.air,
      SexType.oral => Icons.auto_awesome,
      SexType.manual => Icons.front_hand,
      SexType.other => Icons.extension,
    };
  }
}