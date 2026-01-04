import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different levels of sexual protection.
enum SexProtectionType {
  /// No sexual protection.
  none('none'),
  /// Use of barrier methods (e.g., condoms).
  barrier('barrier'),
  /// Use of hormonal methods (e.g., birth control pills).
  hormonal('hormonal'),
  /// Use of natural methods (e.g., fertility awareness).
  natural('natural'),
  /// Permanent methods (e.g., sterilisation).
  permanent('permanent');

  /// The string identifier used for database storage.
  final String dbName;
  
  const SexProtectionType(this.dbName);

  /// Converts a database string back into a [SexProtectionType].
  static SexProtectionType fromDbName(String value) {
    return SexProtectionType.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => SexProtectionType.none,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      SexProtectionType.none => l10n.sexProtection_none,
      SexProtectionType.barrier => l10n.sexProtection_barrier,
      SexProtectionType.hormonal => l10n.sexProtection_hormonal,
      SexProtectionType.natural => l10n.sexProtection_natural,
      SexProtectionType.permanent => l10n.sexProtection_permanent,
    };
  }

  IconData get icon {
    return switch (this) {
      SexProtectionType.none => Icons.close_rounded,
      SexProtectionType.barrier => Icons.shield_rounded,
      SexProtectionType.hormonal => Icons.medication_rounded,
      SexProtectionType.natural => Icons.spa_rounded,
      SexProtectionType.permanent => Icons.lock_rounded,
    };
  }
}