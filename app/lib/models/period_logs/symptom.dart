import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';

class Symptom {
  SymptomType type;
  String customName;

  Symptom({required this.type, this.customName = ""});

  factory Symptom.fromDbString(String value) {
    var symptomType = SymptomType.values.firstWhere(
      (element) => element.toString() == value,
      orElse: () => SymptomType.custom,
    );
    return Symptom(
      type: symptomType,
      customName: symptomType == SymptomType.custom ? value : "",
    );
  }

  factory Symptom.addSymptom() {
    return Symptom(type: SymptomType.other, customName: "+");
  }

  factory Symptom.refreshSymptom() {
    return Symptom(type: SymptomType.other, customName: "↻");
  }

  @override
  bool operator ==(Object other) {
    if (other is Symptom == false) {
      return false;
    }

    var otherSymptom = other as Symptom;

    if (type != otherSymptom.type) {
      return false;
    }

    if (type == SymptomType.custom || type == SymptomType.other) {
      return customName == otherSymptom.customName;
    }

    return true;
  }

  @override
  int get hashCode {
    return type.hashCode + customName.hashCode;
  }
}

extension SymptomExtension on Symptom {
  String getDbName() {
    if (type == SymptomType.custom) {
      return customName;
    }
    return type.toString();
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (type) {
      case SymptomType.builtInAcne:
        return l10n.builtInSymptom_acne;
      case SymptomType.builtInBackPain:
        return l10n.builtInSymptom_backPain;
      case SymptomType.builtInBloating:
        return l10n.builtInSymptom_bloating;
      case SymptomType.builtInCramps:
        return l10n.builtInSymptom_cramps;
      case SymptomType.builtInFatigue:
        return l10n.builtInSymptom_fatigue;
      case SymptomType.builtInHeadache:
        return l10n.builtInSymptom_headache;
      case SymptomType.builtInMoodSwings:
        return l10n.builtInSymptom_moodSwings;
      case SymptomType.builtInNausea:
        return l10n.builtInSymptom_nausea;
      case SymptomType.custom || SymptomType.other:
        return customName;
    }
  }
}
