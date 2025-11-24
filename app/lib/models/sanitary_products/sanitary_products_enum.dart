import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// An enum of sanitary product types.
enum SanitaryProducts {
  tampon,
  pad,
  menstrualCup,
  periodUnderwear,
}

/// Extension to get display values for SanitaryProducts.
extension LarcTypeDisplay on SanitaryProducts {
  /// Gets the localised display name
  String getDisplayName(AppLocalizations l10n) {
    switch (this) { 
      case SanitaryProducts.tampon:
        return l10n.sanitaryProduct_tampon;
      case SanitaryProducts.pad:
        return l10n.sanitaryProduct_pad;
      case SanitaryProducts.menstrualCup:
        return l10n.sanitaryProduct_menstrualCup;
      case SanitaryProducts.periodUnderwear:
        return l10n.sanitaryProduct_periodUnderwear; 
    }
  }

  /// gets the associated icon
  IconData getIcon(){
    switch (this) { 
      case SanitaryProducts.tampon:
        return Icons.circle;
      case SanitaryProducts.pad:
        return Icons.square;
      case SanitaryProducts.menstrualCup:
        return Icons.change_circle;
      case SanitaryProducts.periodUnderwear:
        return Icons.check_box;
    }
  }

  /// The default duration in hours for each sanitary product type
  int get defaultDurationHours {
    switch (this) {
      case SanitaryProducts.tampon:
        return 6;
      case SanitaryProducts.pad:
        return 10;
      case SanitaryProducts.menstrualCup:
        return 12;
      case SanitaryProducts.periodUnderwear:
        return 8;
    }
  }
}
