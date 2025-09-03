import 'package:menstrudel/l10n/app_localizations.dart';

enum Symptom {
  headache,
  fatigue,
  cramps,
  nausea,
  moodSwings,
  bloating,
  acne,
}

extension SymptomExtension on Symptom {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case Symptom.headache:
        return l10n.symptom_headache;
      case Symptom.fatigue:
        return l10n.symptom_fatigue;
      case Symptom.cramps:
        return l10n.symptom_cramps;
      case Symptom.nausea:
        return l10n.symptom_nausea;
      case Symptom.moodSwings:
        return l10n.symptom_moodSwings;
      case Symptom.bloating:
        return l10n.symptom_bloating;
      case Symptom.acne:
        return l10n.symptom_acne;
    }
  }
}