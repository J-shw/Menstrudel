import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// An enum of Long-Acting Reversible Contraceptives (LARCs) types.
enum LarcTypes {
  iud,
  implant,
  injection,
  ring,
  patch;

  /// Gets the localised display name
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) { 
      LarcTypes.iud => l10n.larcType_iud,
      LarcTypes.implant => l10n.larcType_implant,
      LarcTypes.injection => l10n.larcType_injection,
      LarcTypes.ring => l10n.larcType_ring,
      LarcTypes.patch => l10n.larcType_patch,
    };
  }

  /// gets the associated icon
  IconData getIcon(){
    return switch (this) { 
      LarcTypes.iud => Icons.device_thermostat_rounded,
      LarcTypes.implant => Icons.fiber_manual_record_outlined,
      LarcTypes.injection => Icons.medical_services_outlined,
      LarcTypes.ring => Icons.trip_origin_rounded,
      LarcTypes.patch => Icons.square_outlined,
    };
  }

  /// The default duration in days for each LARC type
  int get defaultDurationDays {
    return switch (this) {
      LarcTypes.iud => 1825,
      LarcTypes.implant => 1095,
      LarcTypes.injection => 84,
      LarcTypes.ring => 21,
      LarcTypes.patch => 28,
    };
  }
}
