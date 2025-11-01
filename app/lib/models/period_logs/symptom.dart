import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';

class Symptom {
  SymptomType type;
  String customName;

  Symptom({required this.type, this.customName = ""});

  factory Symptom.fromDbString(String value) {
    final SymptomType type = switch (value) {
      'acne' => SymptomType.acne,
      'back pain' => SymptomType.backPain,
      'bloating' => SymptomType.bloating,
      'cramps' => SymptomType.cramps,
      'fatigue' => SymptomType.fatigue,
      'headache' => SymptomType.headache,
      'mood swings' => SymptomType.moodSwings,
      'nausea' => SymptomType.nausea,
      _ => SymptomType.custom,
    };

    return Symptom(
      type: type,
      customName: type == SymptomType.custom ? value : "",
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
    if (type == SymptomType.custom || type == SymptomType.other) {
      return type.hashCode ^ customName.hashCode;
    }
    return type.hashCode;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

extension SymptomExtension on Symptom {
  String getDbName() {
    switch (type) {
      case SymptomType.acne:
        return 'acne';
      case SymptomType.backPain:
        return 'back pain';
      case SymptomType.bloating:
        return 'bloating';
      case SymptomType.cramps:
        return 'cramps';
      case SymptomType.fatigue:
        return 'fatigue';
      case SymptomType.headache:
        return 'headache';
      case SymptomType.moodSwings:
        return 'mood swings';
      case SymptomType.nausea:
        return 'nausea';
      case SymptomType.custom:
        return customName.toLowerCase();
      case SymptomType.other:
        return customName;
    }
  }

  String getDisplayName(AppLocalizations l10n) {
    switch (type) {
      case SymptomType.acne:
        return l10n.builtInSymptom_acne;
      case SymptomType.backPain:
        return l10n.builtInSymptom_backPain;
      case SymptomType.bloating:
        return l10n.builtInSymptom_bloating;
      case SymptomType.cramps:
        return l10n.builtInSymptom_cramps;
      case SymptomType.fatigue:
        return l10n.builtInSymptom_fatigue;
      case SymptomType.headache:
        return l10n.builtInSymptom_headache;
      case SymptomType.moodSwings:
        return l10n.builtInSymptom_moodSwings;
      case SymptomType.nausea:
        return l10n.builtInSymptom_nausea;
      case SymptomType.custom || SymptomType.other:
        return customName.toCapitalized();
    }
  }
}
