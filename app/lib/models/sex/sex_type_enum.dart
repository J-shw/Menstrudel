import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different types of sex.
enum SexTypes {
  vaginal('vaginal'),
  anal('anal'),
  oral('oral'),
  /// Manual stimulation (e.g., handjob, fingering).
  manual('manual'),
  /// Other types of sexual activity not covered by the above.
  other('other');

  /// The string identifier used for database storage.
  final String dbName;

  const SexTypes(this.dbName);

  /// Converts a database string back into a [SexTypes].
  static SexTypes fromDbName(String value) {
    return SexTypes.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => SexTypes.other,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      SexTypes.vaginal => l10n.sexType_vaginal,
      SexTypes.anal => l10n.sexType_anal,
      SexTypes.oral => l10n.sexType_oral,
      SexTypes.manual => l10n.sexType_manual,
      SexTypes.other => l10n.other,
    };
  }

  /// gets the associated icon
  /// I'm not sure these are the best icons but they will do for now...
  // TODO: revisit icon choices later
  IconData get icon {
    return switch (this) {
      SexTypes.vaginal => Icons.favorite,
      SexTypes.anal => Icons.flare,
      SexTypes.oral => Icons.auto_awesome,
      SexTypes.manual => Icons.front_hand,
      SexTypes.other => Icons.extension,
    };
  }

  Color getColorScheme(ColorScheme colorScheme) {
    switch (this) {
      case SexTypes.vaginal:
        return Colors.pinkAccent;
      case SexTypes.anal:
        return Colors.purpleAccent;
      case SexTypes.oral:
        return Colors.blueAccent;
      case SexTypes.manual:
        return Colors.greenAccent;
      case SexTypes.other:
        return Colors.grey;
    }
  }
}