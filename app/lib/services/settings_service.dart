import 'package:flutter/material.dart';
import 'package:menstrudel/models/app/user_goal_types_enum.dart';
import 'dart:convert';
import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_types_enum.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';

enum PeriodHistoryView { list, journal }

class SettingsService extends ChangeNotifier {
  final SharedPreferences _prefs;

  SettingsService(this._prefs) {
    loadSettings();
  }

  // App
  String _languageCode = kDefaultLanguageCode;
  bool _biometricsEnabled = kDefaultBiometricsEnabled;
  bool _dynamicColorEnabled = kDefaultDynamicColorEnabled;
  Color _themeColor = kDefaultThemeColor;
  AppThemeMode _themeMode = kDefaultThemeMode;
  String _startingDayOfWeek = kDefaultStartingDayOfWeek;
  PeriodHistoryView _historyView = kDefaultHistoryView;

  // Nav
  bool _pillNavEnabled = kDefaultPillNavEnabled;
  bool _reversibleContraceptiveNavEnabled = kDefaultReversibleContraceptiveNavEnabled;
  bool _sanitaryNavEnabled = kDefaultSanitaryNavEnabled;
  bool _sexActivityNavEnabled = kDefaultSexActivityNavEnabled;

  // User
  ReversibleContraceptiveTypes _reversibleContraceptiveType = kDefaultReversibleContraceptiveType;
  Map<ReversibleContraceptiveTypes, int> _reversibleContraceptiveDurations = {};
  bool _phasePredictions = kDefaultPhasePredictions;
  bool _displayFertileChance = kDefaultDisplayFertileChance;
  bool _displayFertileWindowOnCalendar = kDefaultDisplayFertileWindowOnCalendar;

  // Notifications
  bool _periodDueNotificationsEnabled = kDefaultPeriodDueNotificationsEnabled;
  bool _loggingReminder = kDefaultLoggingReminder;
  bool _periodOverdueNotificationsEnabled = kDefaultPeriodOverdueNotificationsEnabled;
  bool _fertileWindowNotificationsEnabled = kDefaultFertileWindowNotificationsEnabled;
  bool _ovulationNotificationsEnabled = kDefaultOvulationNotificationsEnabled;
  bool _reversibleContraceptiveNotificationsEnabled = kDefaultReversibleContraceptiveNotificationsEnabled;

  int _notificationDays = kDefaultNotificationDays;
  int _periodOverdueNotificationDays = kDefaultNotificationDays;
  int _reversibleContraceptiveReminderDays = kDefaultReversibleContraceptiveReminderDays;
  int _fertileWindowReminderDaysBefore = kDefaultNotificationDays;
  int _ovulationReminderDays = kDefaultNotificationDays;

  TimeOfDay _notificationTime = kDefaultNotificationTime;
  TimeOfDay _periodOverdueNotificationTime = kDefaultNotificationTime;
  TimeOfDay _loggingReminderTime = kDefaultNotificationTime;
  TimeOfDay _reversibleContraceptiveReminderTime = kDefaultNotificationTime;
  TimeOfDay _fertileWindowReminderTime = kDefaultNotificationTime;
  TimeOfDay _ovulationReminderTime = kDefaultNotificationTime;

  // App

  /// The selected language code for the app (e.g., 'en', 'es', or 'system').
  String get languageCode => _languageCode;
  /// Whether the app requires biometric authentication (e.g., fingerprint, face) on startup.
  bool get areBiometricsEnabled => _biometricsEnabled;
  /// Whether to use Material You dynamic colors from the wallpaper (Android 12+).
  bool get isDynamicThemeEnabled => _dynamicColorEnabled;
  /// The seed color for the app's theme (used if dynamic color is off).
  Color get themeColor => _themeColor;
  /// The app's theme mode (Light, Dark, or System).
  AppThemeMode get themeMode => _themeMode;
  /// The starting day of the week for calendars
  String get startingDayOfWeek => _startingDayOfWeek;
  /// The user's preferred view for the period history (list vs. journal).
  PeriodHistoryView get historyView => _historyView;

  // Nav

  /// Whether the 'Pill' tab is visible in the main navigation bar.
  bool get isPillNavEnabled => _pillNavEnabled;
  /// Reversible Contraceptive navigation enabled
  bool get isReversibleContraceptiveNavEnabled => _reversibleContraceptiveNavEnabled;
  /// Sanitary Products navigation enabled
  bool get isSanitaryNavEnabled => _sanitaryNavEnabled;
  /// Sex Activity navigation enabled
  bool get isSexActivityNavEnabled => _sexActivityNavEnabled;

  // User

  /// Reversible Contraceptive type selected
  ReversibleContraceptiveTypes get reversibleContraceptiveType => _reversibleContraceptiveType;
  /// Retrieves the duration in days for a specific Reversible Contraceptive type, which determines its estimated renewal date.
  int getReversibleContraceptiveDurationDays(ReversibleContraceptiveTypes type) {
    if (_reversibleContraceptiveDurations.containsKey(type)) {
      return _reversibleContraceptiveDurations[type]!;
    }
    return type.defaultDurationDays; 
  }
  /// Whether phase predictions are enabled.
  bool get arePhasePredictionsEnabled => _phasePredictions;
  /// Whether fertility chance should be displayed on the today tab.
  bool get displayFertileChance => _displayFertileChance;
  /// Whether fertility window should be displayed on the calendar.
  bool get displayFertileWindowOnCalendar => _displayFertileWindowOnCalendar;


  // Notifications

  /// Whether notifications for the *upcoming* period (due) are enabled.
  bool get arePeriodDueNotificationsEnabled => _periodDueNotificationsEnabled;
  /// Whether the logging reminder is enabled
  bool get isLoggingReminderNotificationEnabled => _loggingReminder;
  /// Whether notifications for an *overdue* period are enabled.
  bool get arePeriodOverdueNotificationsEnabled => _periodOverdueNotificationsEnabled;
  /// Whether fertile window notifications are enabled
  bool get areFertileWindowNotificationsEnabled => _fertileWindowNotificationsEnabled;
  /// Whether ovulation notifications are enabled
  bool get areOvulationNotificationsEnabled => _ovulationNotificationsEnabled;
  /// If reversible contraceptive notifications are enabled
  bool get reversibleContraceptiveNotificationsEnabled => _reversibleContraceptiveNotificationsEnabled;

  /// How many days *before* the period is due to send the notification.
  int get notificationDays => _notificationDays;
  /// How many days *after* the period is due to send the overdue notification.
  int get periodOverdueNotificationDays => _periodOverdueNotificationDays;
  /// The amount of days before reversible contraceptive renew date notificaiton shuold be sent
  int get reversibleContraceptiveReminderDays => _reversibleContraceptiveReminderDays;
  /// The amount of days before fertile window notification should be sent
  int get fertileWindowReminderDaysBefore => _fertileWindowReminderDaysBefore;
  /// The amount of days before ovulation notification should be sent
  int get ovulationReminderDays => _ovulationReminderDays;

  /// The time of day to send the 'period due' notification.
  TimeOfDay get notificationTime => _notificationTime;
  /// The time of day to send the 'period overdue' notification.
  TimeOfDay get periodOverdueNotificationTime => _periodOverdueNotificationTime;
  /// The time of day the logging reminder should be sent
  TimeOfDay get loggingReminderTime => _loggingReminderTime;
  /// The time of day the reversible contraceptive renew notification should be sent
  TimeOfDay get reversibleContraceptiveReminderTime => _reversibleContraceptiveReminderTime;
  /// The time of day the fertile window notification should be sent
  TimeOfDay get fertileWindowReminderTime => _fertileWindowReminderTime;
  /// The time of day the ovulation notification should be sent
  TimeOfDay get ovulationReminderTime => _ovulationReminderTime;

  // Other

  /// Returns true if user is on natural cycle (Not using pill or affecting reversible contraceptive).
  bool get isNaturalCycle {
    if (_pillNavEnabled) return false;
    
    if (_reversibleContraceptiveNavEnabled) {
      // Only the Copper IUD allows for a natural hormonal cycle.
      return _reversibleContraceptiveType == ReversibleContraceptiveTypes.copperIud;
    }
    return true;
  }
  
  
  Future<void> loadSettings() async {
    // App
    _languageCode = _loadString(languageKey, kDefaultLanguageCode);
    _biometricsEnabled = _loadBool(biometricEnabledKey, kDefaultBiometricsEnabled);
    _dynamicColorEnabled = _loadBool(dynamicColorKey, kDefaultDynamicColorEnabled);
    _themeColor = _loadThemeColor();
    _themeMode = _loadThemeMode();
    _startingDayOfWeek = _loadString(startingDayOfWeekKey, kDefaultStartingDayOfWeek);
    _historyView = _loadHistoryView();

    // Nav
    _pillNavEnabled = _loadBool(pillNavEnabledKey, kDefaultPillNavEnabled);
    _reversibleContraceptiveNavEnabled = _loadBool(reversibleContraceptiveNavEnabledKey, kDefaultReversibleContraceptiveNavEnabled);
    _sanitaryNavEnabled = _loadBool(sanitaryNavEnabledKey, kDefaultSanitaryNavEnabled);
    _sexActivityNavEnabled = _loadBool(sexActivityNavEnabledKey, kDefaultSexActivityNavEnabled);

    //User
    _reversibleContraceptiveType = _loadReversibleContraceptiveType();
    _reversibleContraceptiveDurations = _loadReversibleContraceptiveDurations();
    _phasePredictions = _loadBool(phasePredictionsKey, kDefaultPhasePredictions);
    _displayFertileChance = _loadBool(displayFertileChanceKey, kDefaultDisplayFertileChance);
    _displayFertileWindowOnCalendar = _loadBool(displayFertileWindowOnCalendarKey, kDefaultDisplayFertileWindowOnCalendar);

    // Notifications
    _periodDueNotificationsEnabled = _loadBool(periodDueNotificationsEnabledKey, kDefaultPeriodDueNotificationsEnabled);
    _periodOverdueNotificationsEnabled = _loadBool(periodOverdueNotificationsEnabledKey, kDefaultPeriodOverdueNotificationsEnabled);
    _reversibleContraceptiveNotificationsEnabled = _loadBool(reversibleContraceptiveNotificationsEnabledKey, kDefaultReversibleContraceptiveNotificationsEnabled);
    _fertileWindowNotificationsEnabled = _loadBool(fertileWindowNotificationsEnabledKey, kDefaultFertileWindowNotificationsEnabled);
    _ovulationNotificationsEnabled = _loadBool(ovulationNotificationsEnabledKey, kDefaultOvulationNotificationsEnabled);
    _loggingReminder = _loadBool(loggingReminderKey, kDefaultLoggingReminder);

    _notificationDays = _loadInt(notificationDaysKey, kDefaultNotificationDays);
    _periodOverdueNotificationDays = _loadInt(periodOverdueNotificationDaysKey, kDefaultNotificationDays);
    _reversibleContraceptiveReminderDays = _loadInt(reversibleContraceptiveNotificationDaysKey, kDefaultReversibleContraceptiveReminderDays);
    _fertileWindowReminderDaysBefore = _loadInt(fertileWindowReminderDaysBeforeKey, kDefaultNotificationDays);
    _ovulationReminderDays = _loadInt(ovulationReminderDaysBeforeKey, kDefaultNotificationDays);

    _notificationTime = _loadTimeOfDay(notificationTimeKey, kDefaultNotificationTime);
    _periodOverdueNotificationTime = _loadTimeOfDay(periodOverdueNotificationTimeKey, kDefaultNotificationTime);
    _loggingReminderTime = _loadTimeOfDay(loggingReminderTimeKey, kDefaultNotificationTime);
    _fertileWindowReminderTime = _loadTimeOfDay(fertileWindowReminderTimeKey, kDefaultNotificationTime);
    _ovulationReminderTime = _loadTimeOfDay(ovulationReminderTimeKey, kDefaultNotificationTime);
    _reversibleContraceptiveReminderTime = _loadTimeOfDay(reversibleContraceptiveNotificationTimeKey, kDefaultNotificationTime);

    notifyListeners();
  }

  TimeOfDay _loadTimeOfDay(String key, TimeOfDay defaultTime) {
    final String? storedTime = _prefs.getString(key);
    if (storedTime == null) {
      return defaultTime;
    }
    final parts = storedTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  bool _loadBool(String key, bool defaultValue) {
    final bool? storedValue = _prefs.getBool(key);
    return storedValue ?? defaultValue;
  }

  int _loadInt(String key, int defaultValue) {
    final int? storedValue = _prefs.getInt(key);
    return storedValue ?? defaultValue;
  }

  String _loadString(String key, String defaultValue) {
    final String? storedValue = _prefs.getString(key);
    return storedValue ?? defaultValue;
  }

  PeriodHistoryView _loadHistoryView() {
    final viewName = _prefs.getString(historyViewKey);
    return PeriodHistoryView.values.firstWhere(
      (e) => e.name == viewName,
      orElse: () => PeriodHistoryView.journal,
    );
  }

  Color _loadThemeColor() {
    final colorValue = _prefs.getInt(themeColorKey) ?? kDefaultThemeColor.toARGB32();
    return Color(colorValue);
  }

  AppThemeMode _loadThemeMode() {
    final themeIndex = _prefs.getInt(themeModeKey) ?? AppThemeMode.system.index;
    return AppThemeMode.values[themeIndex];
  }

  Map<ReversibleContraceptiveTypes, int> _loadReversibleContraceptiveDurations() {
    final String? storedDurationsJson = _prefs.getString(reversibleContraceptiveDurationsKey);
    if (storedDurationsJson != null) {
      final Map<String, dynamic> decodedMap = json.decode(storedDurationsJson);
      
      return decodedMap.map((key, value) {
        final type = ReversibleContraceptiveTypes.values.firstWhere((e) => e.name == key);
        return MapEntry(type, value as int);
      });
    } else {
      return {};
    }
  }

  ReversibleContraceptiveTypes _loadReversibleContraceptiveType() {
    try {
      final String? reversibleContraceptiveTypeString = _prefs.getString(reversibleContraceptiveTypeKey);
      return ReversibleContraceptiveTypes.values.firstWhere(
        (e) => e.name == reversibleContraceptiveTypeString,
      );
    } catch (e) {
      debugPrint('Corrupt saved reversible contraceptive type. Resetting to default.');
      return kDefaultReversibleContraceptiveType;
    }
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

  Future<void> setSanitaryNavEnabled(bool isEnabled) async {
    _sanitaryNavEnabled = isEnabled;
    await _prefs.setBool(sanitaryNavEnabledKey, isEnabled);
    notifyListeners();
  }
  
  Future<void> setReversibleContraceptiveNavEnabled(bool isEnabled) async {
    _reversibleContraceptiveNavEnabled = isEnabled;
    await _prefs.setBool(reversibleContraceptiveNavEnabledKey, isEnabled);
    notifyListeners();
  }

  Future<void> setSexActivityNavEnabled(bool isEnabled) async {
    _sexActivityNavEnabled = isEnabled;
    await _prefs.setBool(sexActivityNavEnabledKey, isEnabled);
    notifyListeners();
  }

  Future<void> setReversibleContraceptiveType(ReversibleContraceptiveTypes type) async {
    _reversibleContraceptiveType = type;
    await _prefs.setString(reversibleContraceptiveTypeKey, type.name);
    notifyListeners();
  }

  Future<void> setReversibleContraceptiveDurationForType(ReversibleContraceptiveTypes type, int durationDays) async {
    _reversibleContraceptiveDurations[type] = durationDays;
    final Map<String, int> mapForStorage = _reversibleContraceptiveDurations.map(
      (key, value) => MapEntry(key.name, value),
    );
    final String encodedJson = json.encode(mapForStorage);
    await _prefs.setString(reversibleContraceptiveDurationsKey, encodedJson);
    notifyListeners();
  }

  Future<void> setReversibleContraceptiveNotificationsEnabled(bool enabled) async {
    _reversibleContraceptiveNotificationsEnabled = enabled;
    await _prefs.setBool(reversibleContraceptiveNotificationsEnabledKey, enabled);
    if (!enabled) {
      await NotificationService.cancelReversibleContraceptiveReminder();
    }
    notifyListeners();
  }

  Future<void> setReversibleContraceptiveReminderDays(int days) async {
    _reversibleContraceptiveReminderDays = days;
    await _prefs.setInt(reversibleContraceptiveNotificationDaysKey, days);
    notifyListeners();
  }

  Future<void> setReversibleContraceptiveReminderTime(TimeOfDay time) async {
    _reversibleContraceptiveReminderTime = time;
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(reversibleContraceptiveNotificationTimeKey, formattedTime);
    notifyListeners();
  }

  Future<void> setLanguageCode(String code) async {
    _languageCode = code;
    await _prefs.setString(languageKey, code);
    notifyListeners();
  }

  Future<void> setBiometricsEnabled(bool isEnabled) async {
    _biometricsEnabled = isEnabled;
    await _prefs.setBool(biometricEnabledKey, isEnabled);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _periodDueNotificationsEnabled = enabled;
    await _prefs.setBool(periodDueNotificationsEnabledKey, enabled);
    if (!enabled) {
      await NotificationService.cancelPillReminder();
    }
    notifyListeners();
  }

  Future<void> setNotificationDays(int days) async {
    _notificationDays = days;
    await _prefs.setInt(notificationDaysKey, days);
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(notificationTimeKey, formattedTime);
    notifyListeners();
  }

  Future<void> setPeriodOverdueNotificationsEnabled(bool isEnabled) async {
    _periodOverdueNotificationsEnabled = isEnabled;
    await _prefs.setBool(periodOverdueNotificationsEnabledKey, isEnabled);
    notifyListeners();
  }

  Future<void> setPeriodOverdueNotificationDays(int days) async {
    _periodOverdueNotificationDays = days;
    await _prefs.setInt(periodOverdueNotificationDaysKey, days);
    notifyListeners();
  }

  Future<void> setPeriodOverdueNotificationTime(TimeOfDay time) async {
    _periodOverdueNotificationTime = time;
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(periodOverdueNotificationTimeKey, formattedTime);
    notifyListeners();
  }

  Future<void> setLoggingReminder(bool isEnabled) async {
    _loggingReminder = isEnabled;
    await _prefs.setBool(loggingReminderKey, isEnabled);
    notifyListeners();
  }

  Future<void> setLoggingReminderTime(TimeOfDay time) async {
    _loggingReminderTime = time;
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(loggingReminderTimeKey, formattedTime);
    notifyListeners();
  }

  Future<void> setFertileWindowNotificationsEnabled(bool enabled) async {
    _fertileWindowNotificationsEnabled = enabled;
    await _prefs.setBool(fertileWindowNotificationsEnabledKey, enabled);
    if (!enabled) {
      await NotificationService.cancelFertileWindowNotification();
    }
    notifyListeners();
  }

  Future<void> setFertileWindowReminderTime(TimeOfDay time) async {
    _fertileWindowReminderTime = time;
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(fertileWindowReminderTimeKey, formattedTime);
    notifyListeners();
  }

  Future<void> setFertileWindowReminderDaysBefore(int days) async {
    _fertileWindowReminderDaysBefore = days;
    await _prefs.setInt(fertileWindowReminderDaysBeforeKey, days);
    notifyListeners();
  }

  Future<void> setOvulationNotificationsEnabled(bool enabled) async {
    _ovulationNotificationsEnabled = enabled;
    await _prefs.setBool(ovulationNotificationsEnabledKey, enabled);
    if (!_ovulationNotificationsEnabled) {
      await NotificationService.cancelOvulationNotification();
    }
    notifyListeners();
  }

  Future<void> setOvulationReminderTime(TimeOfDay time) async {
    _ovulationReminderTime = time;
    final String formattedTime = '${time.hour}:${time.minute}';
    await _prefs.setString(ovulationReminderTimeKey, formattedTime);
    notifyListeners();
  }

  Future<void> setOvulationReminderDaysBefore(int days) async {
    _ovulationReminderDays = days;
    await _prefs.setInt(ovulationReminderDaysBeforeKey, days);
    notifyListeners();
  }

  Future<void> setHistoryView(PeriodHistoryView view) async {
    _historyView = view;
    await _prefs.setString(historyViewKey, view.name);
    notifyListeners();
  }

  Future<void> setDynamicColorEnabled(bool isEnabled) async {
    _dynamicColorEnabled = isEnabled;
    await _prefs.setBool(dynamicColorKey, isEnabled);
    notifyListeners();
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    await _prefs.setInt(themeColorKey, color.toARGB32());
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode theme) async {
    _themeMode = theme;
    await _prefs.setInt(themeModeKey, theme.index);
    notifyListeners();
  }

  Future<void> setStartingDayOfWeek(String day) async {
    _startingDayOfWeek = day;
    await _prefs.setString(startingDayOfWeekKey, day);
    notifyListeners();
  }

  Future<void> applySettingsForGoal(UserGoalTypes goal) async {
    final preset = goal.settings;

    // I'm not using the class methods because they will each notifyListeners which would result in 2 notify events.

    _sanitaryNavEnabled = preset.sanitaryNav;
    _sexActivityNavEnabled = preset.sexNav;

    await Future.wait([
      _prefs.setBool(sanitaryNavEnabledKey, _sanitaryNavEnabled),
      _prefs.setBool(sexActivityNavEnabledKey, _sexActivityNavEnabled)
    ]);
    
    notifyListeners();
  }

  /// Enable/Disable phase predictions
  Future<void> setPhasePredictions(bool enabled) async {
    _phasePredictions = enabled;
    await _prefs.setBool(phasePredictionsKey, enabled);
    notifyListeners();
  }

  /// Enable/Disable fertile chance display on today tab
  Future<void> setDisplayFertileChance(bool enabled) async {
    _displayFertileChance = enabled;
    await _prefs.setBool(displayFertileChanceKey, enabled);
    notifyListeners();
  }

  /// Enable/Disable fertile window display on calendar
  Future<void> setDisplayFertileWindowOnCalendar(bool enabled) async {
    _displayFertileWindowOnCalendar = enabled;
    await _prefs.setBool(displayFertileWindowOnCalendarKey, enabled);
    notifyListeners();
  }
}