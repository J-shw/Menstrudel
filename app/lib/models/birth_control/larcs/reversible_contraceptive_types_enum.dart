import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

/// Defines contraceptive methods that are duration-based and reversible.
/// 
/// Daily contraceptive pills are excluded from this enum and handled by a separate system
enum ReversibleContraceptiveTypes {
  hormonalIud,
  copperIud,
  implant,
  injection,
  ring,
  patch;

  /// Gets the localised display name
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) { 
      ReversibleContraceptiveTypes.hormonalIud => l10n.reversibleContraceptive_hormonalIud,
      ReversibleContraceptiveTypes.copperIud => l10n.reversibleContraceptive_copperIud,
      ReversibleContraceptiveTypes.implant => l10n.reversibleContraceptive_implant,
      ReversibleContraceptiveTypes.injection => l10n.reversibleContraceptive_injection,
      ReversibleContraceptiveTypes.ring => l10n.reversibleContraceptive_ring,
      ReversibleContraceptiveTypes.patch => l10n.reversibleContraceptive_patch,
    };
  }

  /// gets the associated icon
  IconData getIcon(){
    return switch (this) { 
      ReversibleContraceptiveTypes.hormonalIud => Icons.device_thermostat_rounded,
      ReversibleContraceptiveTypes.copperIud => Icons.device_thermostat_rounded,
      ReversibleContraceptiveTypes.implant => Icons.horizontal_rule_rounded,
      ReversibleContraceptiveTypes.injection => Icons.vaccines_rounded,
      ReversibleContraceptiveTypes.ring => Icons.trip_origin_rounded,
      ReversibleContraceptiveTypes.patch => Icons.layers_rounded,
    };
  }

  /// The default duration in days for each contraception type
  int get defaultDurationDays {
    return switch (this) {
      ReversibleContraceptiveTypes.hormonalIud => 1825,
      ReversibleContraceptiveTypes.copperIud => 3650,
      ReversibleContraceptiveTypes.implant => 1095,
      ReversibleContraceptiveTypes.injection => 84,
      ReversibleContraceptiveTypes.ring => 21,
      ReversibleContraceptiveTypes.patch => 28,
    };
  }
}
