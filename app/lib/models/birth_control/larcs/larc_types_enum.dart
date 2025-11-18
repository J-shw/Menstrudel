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

/// Extension to get localized display names for LarcTypes.
extension LarcTypeDisplay on LarcTypes {
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
}