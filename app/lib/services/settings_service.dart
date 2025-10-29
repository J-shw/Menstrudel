import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';

enum PeriodHistoryView { list, journal }

class SettingsService {

  Future<void> deleteAllSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> setLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, code);
  }

  Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey) ?? 'system';
  }

  Future<void> setAlwaysShowReminderButtonEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(persistentReminderKey, isEnabled);
  }

  Future<bool> areAlwaysShowReminderButtonEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(persistentReminderKey) ?? false;
  }

  Future<void> setBiometricsEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(biometricEnabledKey, isEnabled);
  }

  Future<bool> areBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(biometricEnabledKey) ?? false;
  }

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationsEnabledKey, isEnabled);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(notificationDaysKey, days);
  }

  Future<int> getNotificationDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(notificationDaysKey) ?? 1;
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedTime = '${time.hour}:${time.minute}';
    await prefs.setString(notificationTimeKey, formattedTime);
  }

  Future<TimeOfDay> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedTime = prefs.getString(notificationTimeKey);

    if (storedTime == null) {
      return const TimeOfDay(hour: 9, minute: 0);
    }

    final parts = storedTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Period Overdue Notifications

  Future<void> setPeriodOverdueNotificationsEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(periodOverdueNotificationsEnabledKey, isEnabled);
  }

  Future<bool> arePeriodOverdueNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(periodOverdueNotificationsEnabledKey) ?? true;
  }

  Future<void> setPeriodOverdueNotificationDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(periodOverdueNotificationDaysKey, days);
  }

  Future<int> getPeriodOverdueNotificationDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(periodOverdueNotificationDaysKey) ?? 1;
  }

  Future<void> setPeriodOverdueNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedTime = '${time.hour}:${time.minute}';
    await prefs.setString(periodOverdueNotificationTimeKey, formattedTime);
  }

  Future<TimeOfDay> getPeriodOverdueNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedTime = prefs.getString(periodOverdueNotificationTimeKey);

    if (storedTime == null) {
      return const TimeOfDay(hour: 9, minute: 0);
    }

    final parts = storedTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> setHistoryView(PeriodHistoryView view) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(historyViewKey, view.name);
  }

  Future<PeriodHistoryView> getHistoryView() async {
    final prefs = await SharedPreferences.getInstance();
    final viewName = prefs.getString(historyViewKey);
    return PeriodHistoryView.values.firstWhere(
      (e) => e.name == viewName,
      orElse: () => PeriodHistoryView.journal,
    );
  }

  Future<void> setDynamicColorEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(dynamicColorKey, isEnabled);
  }
  Future<bool> isDynamicThemeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(dynamicColorKey) ?? false;
    return isEnabled;
  }

  Future<void> setThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeColorKey, color.toARGB32());
  }
  Future<Color> getThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(themeColorKey) ?? seedColor.toARGB32();
    return Color(colorValue);
  }

  Future<void> setThemeMode(AppThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, theme.index);
  }
  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeModeKey) ?? AppThemeMode.system.index;
    return AppThemeMode.values[themeIndex];
  }

  Future<Set<Symptom>> getDefaultSymptoms() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDefaultSymptoms = prefs.getStringList(defaultSymptomsKey);

    if (storedDefaultSymptoms == null || storedDefaultSymptoms.isEmpty) {
      return Symptom.getBuiltInSymptoms();
    }

    return storedDefaultSymptoms.map((e) => Symptom.fromDbString(e)).toSet();
  }

  Future<void> setDefaultSymptoms(Set<Symptom> symptoms) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(defaultSymptomsKey, symptoms.map((e) => e.type == SymptomType.custom ? e.customName : e.type.toString()).toList());
  }

  Future<void> addDefaultSymptom(Symptom symptom) async {
    var defaultSymptoms = await getDefaultSymptoms();
    defaultSymptoms.add(symptom);
    await setDefaultSymptoms(defaultSymptoms);
  }

  Future<void> removeDefaultSymptom(Symptom symptom) async {
    var defaultSymptoms = await getDefaultSymptoms();
    defaultSymptoms.remove(symptom);
    await setDefaultSymptoms(defaultSymptoms);
  }
}