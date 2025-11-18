import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// An enum of Long-Acting Reversible Contraceptives (LARCs) types.
/// Currently only injection is supported, but more may be added in the future, so I have added some as placeholders.
enum LarcTypes {
  iud,
  implant,
  injection,
  ring,
  patch,
}

/// Extension to get display values for LarcTypes.
extension LarcTypeDisplay on LarcTypes {
  /// Gets the localised display name
  String getDisplayName(AppLocalizations l10n) {
    switch (this) { 
      case LarcTypes.iud:
        return l10n.larcType_iud; 
      case LarcTypes.implant:
        return l10n.larcType_implant;
      case LarcTypes.injection:
        return l10n.larcType_injection;
      case LarcTypes.ring:
        return l10n.larcType_ring;
      case LarcTypes.patch:
        return l10n.larcType_patch;
    }
  }

  /// gets the associated icon (Not sure if needed but have place holder icons for now...)
  IconData getIcon(){
    switch (this) { 
      case LarcTypes.iud:
        return Icons.input; 
      case LarcTypes.implant:
        return Icons.arrow_back_rounded;
      case LarcTypes.injection:
        return Icons.back_hand;
      case LarcTypes.ring:
        return Icons.ring_volume;
      case LarcTypes.patch:
        return Icons.pivot_table_chart;
    }
  }
}
