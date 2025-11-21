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

  /// gets the associated icon
  IconData getIcon(){
    switch (this) { 
      case LarcTypes.iud:
        return Icons.device_thermostat_rounded; 
      case LarcTypes.implant:
        return Icons.fiber_manual_record_outlined;
      case LarcTypes.injection:
        return Icons.medical_services_outlined;
      case LarcTypes.ring:
        return Icons.trip_origin_rounded;
      case LarcTypes.patch:
        return Icons.square_outlined;
    }
  }

  /// The default duration in days for each LARC type
  int get defaultDurationDays {
    switch (this) {
      case LarcTypes.iud:
        return 1825; 
      case LarcTypes.implant:
        return 1095;
      case LarcTypes.injection:
        return 84; 
      case LarcTypes.ring:
        return 21;
      case LarcTypes.patch:
        return 28;
    }
  }
}
