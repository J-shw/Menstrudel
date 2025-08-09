import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationDaysKey = 'notification_days';

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
}