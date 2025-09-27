import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';

enum PeriodHistoryView { list, journal }

class SettingsService {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationDaysKey = 'notification_days';
  static const _notificationTimeKey = 'notification_time';
  static const String _periodOverdueNotificationsEnabledKey = 'period_overdue_notifications_enabled';
  static const String _periodOverdueNotificationDaysKey = 'period_overdue_notification_days';
  static const _periodOverdueNotificationTimeKey = 'period_overdue_notification_time';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _historyViewKey = 'history_view';
  static const _dynamicColorKey = 'dynamic_color';
  static const _themeColorKey = 'theme_color';
  static const _themeModeKey = 'theme_mode';

  Future<void> deleteAllSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> setBiometricsEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, isEnabled);
  }

  Future<bool> areBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  Future<void> setNotificationsEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, isEnabled);
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_notificationDaysKey, days);
  }

  Future<int> getNotificationDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_notificationDaysKey) ?? 1;
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedTime = '${time.hour}:${time.minute}';
    await prefs.setString(_notificationTimeKey, formattedTime);
  }

  Future<TimeOfDay> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedTime = prefs.getString(_notificationTimeKey);

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
    await prefs.setBool(_periodOverdueNotificationsEnabledKey, isEnabled);
  }

  Future<bool> arePeriodOverdueNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_periodOverdueNotificationsEnabledKey) ?? true;
  }

  Future<void> setPeriodOverdueNotificationDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_periodOverdueNotificationDaysKey, days);
  }

  Future<int> getPeriodOverdueNotificationDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_periodOverdueNotificationDaysKey) ?? 1;
  }

  Future<void> setPeriodOverdueNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final String formattedTime = '${time.hour}:${time.minute}';
    await prefs.setString(_periodOverdueNotificationTimeKey, formattedTime);
  }

  Future<TimeOfDay> getPeriodOverdueNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedTime = prefs.getString(_periodOverdueNotificationTimeKey);

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
    await prefs.setString(_historyViewKey, view.name);
  }

  Future<PeriodHistoryView> getHistoryView() async {
    final prefs = await SharedPreferences.getInstance();
    final viewName = prefs.getString(_historyViewKey);
    return PeriodHistoryView.values.firstWhere(
      (e) => e.name == viewName,
      orElse: () => PeriodHistoryView.journal,
    );
  }

  Future<void> setDynamicColorEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dynamicColorKey, isEnabled);
  }
  Future<bool> isDynamicThemeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_dynamicColorKey) ?? false;
    return isEnabled;
  }

  Future<void> setThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeColorKey, color.toARGB32());
  }
  Future<Color> getThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_themeColorKey) ?? seedColor.toARGB32();
    return Color(colorValue);
  }

  Future<void> setThemeMode(AppThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, theme.index);
  }
  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? AppThemeMode.system.index;
    return AppThemeMode.values[themeIndex];
  }
}