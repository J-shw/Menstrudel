import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different levels of sexual protection.
enum SexProtectionTypes {
  /// No sexual protection.
  none('none'),
  /// Use of barrier methods (e.g., condoms).
  barrier('barrier'),
  /// Use of hormonal methods (e.g., birth control pills).
  hormonal('hormonal'),
  /// Use of non-hormonal methods (e.g., copper IUD).
  nonHormonal('non_hormonal'),
  /// Use of natural methods (e.g., fertility awareness).
  natural('natural'),
  /// Permanent methods (e.g., sterilisation).
  permanent('permanent');

  /// The string identifier used for database storage.
  final String dbName;
  
  const SexProtectionTypes(this.dbName);

  /// Converts a database string back into a [SexProtectionTypes].
  static SexProtectionTypes fromDbName(String value) {
    return SexProtectionTypes.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => SexProtectionTypes.none,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      SexProtectionTypes.none => l10n.sexProtection_none,
      SexProtectionTypes.barrier => l10n.sexProtection_barrier,
      SexProtectionTypes.hormonal => l10n.sexProtection_hormonal,
      SexProtectionTypes.nonHormonal => l10n.sexProtection_nonHormonal,
      SexProtectionTypes.natural => l10n.sexProtection_natural,
      SexProtectionTypes.permanent => l10n.sexProtection_permanent,
    };
  }

  IconData get icon {
    return switch (this) {
      SexProtectionTypes.none => Icons.close_rounded,
      SexProtectionTypes.barrier => Icons.shield_rounded,
      SexProtectionTypes.hormonal => Icons.medication_rounded,
      SexProtectionTypes.nonHormonal => Icons.health_and_safety_rounded,
      SexProtectionTypes.natural => Icons.spa_rounded,
      SexProtectionTypes.permanent => Icons.lock_rounded,
    };
  }
}