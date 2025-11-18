import 'package:flutter/material.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/period_logs/symptom_type_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';

enum PeriodHistoryView { list, journal }

class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _pillNavEnabled = kDefaultPillNavEnabled;
  bool _isLarcNavEnabled = kDefaultLarcNavEnabled;
  String _larcType = kDefaultLarcType;
  String _languageCode = kDefaultLanguageCode;
  bool _alwaysShowReminderButton = kDefaultAlwaysShowReminderButton;
  bool _biometricsEnabled = kDefaultBiometricsEnabled;
  bool _notificationsEnabled = kDefaultNotificationsEnabled;
  int _notificationDays = kDefaultNotificationDays;
  TimeOfDay _notificationTime = kDefaultNotificationTime;
  bool _periodOverdueNotificationsEnabled = kDefaultPeriodOverdueNotificationsEnabled;
  int _periodOverdueNotificationDays = kDefaultPeriodOverdueNotificationDays;
  TimeOfDay _periodOverdueNotificationTime = kDefaultPeriodOverdueNotificationTime;
  PeriodHistoryView _historyView = kDefaultHistoryView;
  bool _dynamicColorEnabled = kDefaultDynamicColorEnabled;
  Color _themeColor = kDefaultThemeColor;
  AppThemeMode _themeMode = kDefaultThemeMode;
  Set<Symptom> _defaultSymptoms = kDefaultSymptoms;

  /// Whether the 'Pill' tab is visible in the main navigation bar.
  bool get isPillNavEnabled => _pillNavEnabled;
  /// LARCs (Long-Acting Reversible Contraceptives) navigation enabled
  bool get isLarcNavEnabled => _isLarcNavEnabled;
  /// LARC type selected
  String get larcType => _larcType;
  /// The selected language code for the app (e.g., 'en', 'es', or 'system').
  String get languageCode => _languageCode;
  /// Whether the tampon reminder FAB is persistently shown on the Logs screen.
  bool get areAlwaysShowReminderButtonEnabled => _alwaysShowReminderButton;
  /// Whether the app requires biometric authentication (e.g., fingerprint, face) on startup.
  bool get areBiometricsEnabled => _biometricsEnabled;
  /// Whether notifications for the *upcoming* period (due) are enabled.
  bool get areNotificationsEnabled => _notificationsEnabled;
  /// How many days *before* the period is due to send the notification.
  int get notificationDays => _notificationDays;
  /// The time of day to send the 'period due' notification.
  TimeOfDay get notificationTime => _notificationTime;
  /// Whether notifications for an *overdue* period are enabled.
  bool get arePeriodOverdueNotificationsEnabled =>
      _periodOverdueNotificationsEnabled;
  /// How many days *after* the period is due to send the overdue notification.
  int get periodOverdueNotificationDays => _periodOverdueNotificationDays;
  /// The time of day to send the 'period overdue' notification.
  TimeOfDay get periodOverdueNotificationTime => _periodOverdueNotificationTime;
  /// The user's preferred view for the period history (list vs. journal).
  PeriodHistoryView get historyView => _historyView;
  /// Whether to use Material You dynamic colors from the wallpaper (Android 12+).
  bool get isDynamicThemeEnabled => _dynamicColorEnabled;
  /// The seed color for the app's theme (used if dynamic color is off).
  Color get themeColor => _themeColor;
  /// The app's theme mode (Light, Dark, or System).
  AppThemeMode get themeMode => _themeMode;
  /// The user configured default symptoms
  Set<Symptom> get defaultSymptoms => _defaultSymptoms;

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _pillNavEnabled = _prefs.getBool(pillNavEnabledKey) ?? false;
    _isLarcNavEnabled = _prefs.getBool(pillNavEnabledKey) ?? false;
    _languageCode = _prefs.getString(languageKey) ?? 'system';
    _alwaysShowReminderButton = _prefs.getBool(persistentReminderKey) ?? false;
    _biometricsEnabled = _prefs.getBool(biometricEnabledKey) ?? false;
    _notificationsEnabled = _prefs.getBool(notificationsEnabledKey) ?? true;
    _notificationDays = _prefs.getInt(notificationDaysKey) ?? 1;
    _notificationTime = _loadTimeOfDay(notificationTimeKey, 9, 0);

    _periodOverdueNotificationsEnabled = _prefs.getBool(periodOverdueNotificationsEnabledKey) ?? true;
    _periodOverdueNotificationDays = _prefs.getInt(periodOverdueNotificationDaysKey) ?? 1;
    _periodOverdueNotificationTime = _loadTimeOfDay(periodOverdueNotificationTimeKey, 9, 0);

    _historyView = _loadHistoryView();
    _dynamicColorEnabled = _prefs.getBool(dynamicColorKey) ?? false;
    _themeColor = _loadThemeColor();
    _themeMode = _loadThemeMode();

    _defaultSymptoms = _loadDefaultSymptoms();

    notifyListeners();
  }

  TimeOfDay _loadTimeOfDay(String key, int defaultHour, int defaultMinute) {
    final String? storedTime = _prefs.getString(key);
    if (storedTime == null) {
      return TimeOfDay(hour: defaultHour, minute: defaultMinute);
    }
    final parts = storedTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  PeriodHistoryView _loadHistoryView() {
    final viewName = _prefs.getString(historyViewKey);
    return PeriodHistoryView.values.firstWhere(
      (e) => e.name == viewName,
      orElse: () => PeriodHistoryView.journal,
    );
  }

  Color _loadThemeColor() {
    final colorValue = _prefs.getInt(themeColorKey) ?? seedColor.toARGB32();
    return Color(colorValue);
  }

  AppThemeMode _loadThemeMode() {
    final themeIndex = _prefs.getInt(themeModeKey) ?? AppThemeMode.system.index;
    return AppThemeMode.values[themeIndex];
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

  Future<void> deleteAllSettings() async {
    await _prefs.clear();
    await loadSettings();
  }

  Future<void> setPillNavEnabled(bool isEnabled) async {
    _pillNavEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(pillNavEnabledKey, isEnabled);
  }
  
  Future<void> setLarcNavEnabled(bool isEnabled) async {
    _isLarcNavEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(larcNavEnabledKey, isEnabled);
  }

  Future<void> setLarcType(LarcTypes type) async {
    _larcType = type.name;
    notifyListeners();
    await _prefs.setString(larcTypeKey, _larcType);
  }

  Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    notifyListeners();
    await _prefs.setString(languageKey, code);
  }

  Future<void> setAlwaysShowReminderButtonEnabled(bool isEnabled) async {
    _alwaysShowReminderButton = isEnabled;
    notifyListeners();
    await _prefs.setBool(persistentReminderKey, isEnabled);
  }

  Future<void> setBiometricsEnabled(bool isEnabled) async {
    _biometricsEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(biometricEnabledKey, isEnabled);
  }

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    _notificationsEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(notificationsEnabledKey, isEnabled);
  }

  Future<void> setNotificationDays(int days) async {
    _notificationDays = days;
    notifyListeners();
    await _prefs.setInt(notificationDaysKey, days);
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    notifyListeners();
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(notificationTimeKey, formattedTime);
  }

  Future<void> setPeriodOverdueNotificationsEnabled(bool isEnabled) async {
    _periodOverdueNotificationsEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(periodOverdueNotificationsEnabledKey, isEnabled);
  }

  Future<void> setPeriodOverdueNotificationDays(int days) async {
    _periodOverdueNotificationDays = days;
    notifyListeners();
    await _prefs.setInt(periodOverdueNotificationDaysKey, days);
  }

  Future<void> setPeriodOverdueNotificationTime(TimeOfDay time) async {
    _periodOverdueNotificationTime = time;
    notifyListeners();
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(periodOverdueNotificationTimeKey, formattedTime);
  }

  Future<void> setHistoryView(PeriodHistoryView view) async {
    _historyView = view;
    notifyListeners();
    await _prefs.setString(historyViewKey, view.name);
  }

  Future<void> setDynamicColorEnabled(bool isEnabled) async {
    _dynamicColorEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(dynamicColorKey, isEnabled);
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    notifyListeners();
    await _prefs.setInt(themeColorKey, color.toARGB32());
  }

  Future<void> setThemeMode(AppThemeMode theme) async {
    _themeMode = theme;
    notifyListeners();
    await _prefs.setInt(themeModeKey, theme.index);
  }

  Future<void> setDefaultSymptoms(Set<Symptom> symptoms) async {
    _defaultSymptoms = symptoms;
    notifyListeners();
    await _prefs.setStringList(
      defaultSymptomsKey, 
      symptoms.map((e) => e.getDbName()).toList()
    );
  }

  Future<void> resetDefaultSymptoms() async {
    await _prefs.remove(defaultSymptomsKey);
    final defaultSet = _loadDefaultSymptoms();
    await setDefaultSymptoms(defaultSet);
  }

  Future<void> addDefaultSymptom(Symptom symptom) async {
    final newSet = Set<Symptom>.from(_defaultSymptoms);
    newSet.add(symptom);
    await setDefaultSymptoms(newSet);
  }

  Future<void> removeDefaultSymptom(Symptom symptom) async {
    final newSet = Set<Symptom>.from(_defaultSymptoms);
    newSet.remove(symptom);
    await setDefaultSymptoms(newSet);
  }
}