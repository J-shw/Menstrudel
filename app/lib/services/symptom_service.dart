import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user symptoms and related data.
class SymptomService extends ChangeNotifier {
  final SharedPreferences _prefs;

  SymptomService(this._prefs) {
    load();
  }

  Set<Symptom> _symptoms = kDefaultSymptoms;

  /// Symptoms that are available for the user to select from when logging their period.
  Set<Symptom> get symptoms => _symptoms;


  Future<void> load() async {
    _symptoms = _loadDefaultSymptoms();
  }

  Set<Symptom> _loadDefaultSymptoms() {
    final storedDefaultSymptoms = _prefs.getStringList(defaultSymptomsKey);

    if (storedDefaultSymptoms == null || storedDefaultSymptoms.isEmpty) {
      return SymptomType.values
          .where(
            (element) =>
                element != SymptomType.custom,
          )
          .map((e) => Symptom(type: e))
          .toSet();
    }
    return storedDefaultSymptoms.map((e) => Symptom.fromDbString(e)).toSet();
  }

  Future<void> _setSymptoms(Set<Symptom> symptoms) async {
    _symptoms = symptoms;
    await _prefs.setStringList(
      defaultSymptomsKey, 
      symptoms.map((e) => e.getDbName()).toList()
    );
    notifyListeners();
  }

  /// Resets the symptoms to the default set defined in [kDefaultSymptoms].
  Future<void> resetSymptoms() async {
    await _prefs.remove(defaultSymptomsKey);
    final defaultSet = _loadDefaultSymptoms();
    await _setSymptoms(defaultSet);
  }

  /// Adds a new symptom to the current set of symptoms and updates the stored data.
  Future<void> addSymptom(Symptom symptom) async {
    final newSet = Set<Symptom>.from(_symptoms);
    newSet.add(symptom);
    await _setSymptoms(newSet);
  }

  /// Removes a symptom from the current set of symptoms and updates the stored data.
  Future<void> removeSymptom(Symptom symptom) async {
    final newSet = Set<Symptom>.from(_symptoms);
    newSet.remove(symptom);
    await _setSymptoms(newSet);
  }
}