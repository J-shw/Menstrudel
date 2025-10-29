import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';

enum PeriodHistoryView { list, journal }

class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _pillNavEnabled = kDefaultPillNavEnabled;
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

  bool get isPillNavEnabled => _pillNavEnabled;
  String get languageCode => _languageCode;
  bool get areAlwaysShowReminderButtonEnabled => _alwaysShowReminderButton;
  bool get areBiometricsEnabled => _biometricsEnabled;
  bool get areNotificationsEnabled => _notificationsEnabled;
  int get notificationDays => _notificationDays;
  TimeOfDay get notificationTime => _notificationTime;
  bool get arePeriodOverdueNotificationsEnabled =>
      _periodOverdueNotificationsEnabled;
  int get periodOverdueNotificationDays => _periodOverdueNotificationDays;
  TimeOfDay get periodOverdueNotificationTime => _periodOverdueNotificationTime;
  PeriodHistoryView get historyView => _historyView;
  bool get isDynamicThemeEnabled => _dynamicColorEnabled;
  Color get themeColor => _themeColor;
  AppThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _pillNavEnabled = _prefs.getBool(pillNavEnabledKey) ?? false;
    _languageCode = _prefs.getString(languageKey) ?? 'system';
    _alwaysShowReminderButton =
        _prefs.getBool(persistentReminderKey) ?? false;
    _biometricsEnabled = _prefs.getBool(biometricEnabledKey) ?? false;
    _notificationsEnabled = _prefs.getBool(notificationsEnabledKey) ?? true;
    _notificationDays = _prefs.getInt(notificationDaysKey) ?? 1;
    _notificationTime = _loadTimeOfDay(notificationTimeKey, 9, 0);

    _periodOverdueNotificationsEnabled =
        _prefs.getBool(periodOverdueNotificationsEnabledKey) ?? true;
    _periodOverdueNotificationDays =
        _prefs.getInt(periodOverdueNotificationDaysKey) ?? 1;
    _periodOverdueNotificationTime =
        _loadTimeOfDay(periodOverdueNotificationTimeKey, 9, 0);

    _historyView = _loadHistoryView();
    _dynamicColorEnabled = _prefs.getBool(dynamicColorKey) ?? false;
    _themeColor = _loadThemeColor();
    _themeMode = _loadThemeMode();

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

  Future<void> deleteAllSettings() async {
    await _prefs.clear();
    await loadSettings();
  }

  Future<void> setPillNavEnabled(bool isEnabled) async {
    _pillNavEnabled = isEnabled;
    notifyListeners();
    await _prefs.setBool(pillNavEnabledKey, isEnabled);
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
}