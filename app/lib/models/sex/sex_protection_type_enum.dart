import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing different levels of sexual protection.
enum SexProtectionType {
  /// No sexual protection.
  none,
  /// Use of barrier methods (e.g., condoms).
  barrier,
  /// Use of hormonal methods (e.g., birth control pills).
  hormonal,
  /// Use of natural methods (e.g., fertility awareness).
  natural,
  /// Permanent methods (e.g., sterilisation).
  permanent,
}

extension SexProtectionTypeExtension on SexProtectionType {
  String getDbName() {
    switch (this) {
      case SexProtectionType.none:
        return 'none';
      case SexProtectionType.barrier:
        return 'barrier';
      case SexProtectionType.hormonal:
        return 'hormonal';
      case SexProtectionType.natural:
        return 'natural';
      case SexProtectionType.permanent:
        return 'permanent';
    }
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case SexProtectionType.none:
        return l10n.sexProtection_none;
      case SexProtectionType.barrier:
        return l10n.sexProtection_barrier;
      case SexProtectionType.hormonal:
        return l10n.sexProtection_hormonal;
      case SexProtectionType.natural:
        return l10n.sexProtection_natural;
      case SexProtectionType.permanent:
        return l10n.sexProtection_permanent;
    }
  }

  /// gets the associated icon
  IconData getIcon() {
    switch (this) {
      case SexProtectionType.none:
        return Icons.close_rounded;
      case SexProtectionType.barrier:
        return Icons.shield_rounded;
      case SexProtectionType.hormonal:
        return Icons.medication_rounded;
      case SexProtectionType.natural:
        return Icons.spa_rounded;
      case SexProtectionType.permanent:
        return Icons.lock_rounded;
    }
  }
}