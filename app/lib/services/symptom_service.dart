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
  /// The default set of symptoms that are available to the user when they first use the app.
  Set<Symptom> get defaultSymptoms => kDefaultSymptoms;
  /// Custom symptoms that the user has added to their symptom list.
  Set<Symptom> get customSymptoms => _symptoms.where((s) => s.type == SymptomType.custom).toSet();
  /// Symptoms that are not custom symptoms.
  Set<Symptom> get nonCustomSymptoms => _symptoms.where((s) => s.type != SymptomType.custom).toSet();
  /// Returns symptoms ordered by likelihood based on age (Cunningham et al. 2024).
  /// Custom symptoms are appended to the end.
  List<Symptom> ageOrderedSymptoms(int? age) {
    if (age == null) return _symptoms.toList();

    final order = _getPriorityListForAge(age);
    List<Symptom> sortedList = _symptoms.toList();

    sortedList.sort((a, b) {
      int indexA = order.indexOf(a.type);
      int indexB = order.indexOf(b.type);

      if (indexA == -1) indexA = 99;
      if (indexB == -1) indexB = 99;

      return indexA.compareTo(indexB);
    });

    return sortedList;
  }

  Future<void> load() async {
    _symptoms = _loadDefaultSymptoms();
  }

  /// Gets the age priority list for symptoms based on the study by Cunningham et al. (2024).
  /// This list is used to order symptoms by likelihood for different age groups.
  /// All built in symptoms are included in the list, but their order changes based on age.
  List<SymptomType> _getPriorityListForAge(int age) {
    if (age <= 25) {
      return [SymptomType.cramps, SymptomType.tenderBreasts, SymptomType.fatigue, SymptomType.backPain, SymptomType.acne, SymptomType.bloating, SymptomType.moodSwings, SymptomType.headache, SymptomType.nausea, SymptomType.insomnia, SymptomType.depressed];
    } else if (age <= 30) {
      return [SymptomType.cramps, SymptomType.fatigue, SymptomType.tenderBreasts, SymptomType.bloating, SymptomType.backPain, SymptomType.headache, SymptomType.acne, SymptomType.moodSwings, SymptomType.nausea, SymptomType.insomnia, SymptomType.depressed];
    } else if (age <= 35) {
      return [SymptomType.cramps, SymptomType.fatigue, SymptomType.tenderBreasts, SymptomType.bloating, SymptomType.backPain, SymptomType.headache, SymptomType.acne, SymptomType.moodSwings, SymptomType.nausea, SymptomType.insomnia, SymptomType.depressed];
    } else if (age <= 40) {
      return [SymptomType.cramps, SymptomType.fatigue, SymptomType.tenderBreasts, SymptomType.headache, SymptomType.bloating, SymptomType.backPain, SymptomType.moodSwings, SymptomType.acne, SymptomType.nausea, SymptomType.insomnia, SymptomType.depressed];
    } else if (age <= 45) {
      return [SymptomType.cramps, SymptomType.tenderBreasts, SymptomType.fatigue, SymptomType.headache, SymptomType.backPain, SymptomType.bloating, SymptomType.moodSwings, SymptomType.acne, SymptomType.insomnia, SymptomType.depressed, SymptomType.nausea];
    } else if (age <= 50) {
      return [SymptomType.cramps, SymptomType.tenderBreasts, SymptomType.headache, SymptomType.backPain, SymptomType.fatigue, SymptomType.bloating, SymptomType.moodSwings, SymptomType.insomnia, SymptomType.depressed, SymptomType.acne, SymptomType.nausea];
    } else {
      return [SymptomType.cramps, SymptomType.headache, SymptomType.tenderBreasts, SymptomType.fatigue, SymptomType.backPain, SymptomType.bloating, SymptomType.moodSwings, SymptomType.insomnia, SymptomType.depressed, SymptomType.acne, SymptomType.nausea];
    }
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