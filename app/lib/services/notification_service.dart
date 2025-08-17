import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
  debugPrint('Notification tapped: ${notificationResponse.payload}');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  debugPrint('Background notification tapped: ${notificationResponse.payload}');
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const int _periodNotificationId = 1;
  static const int _tamponReminderId = 2;
  static const int _pillReminderId = 3;

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Perdiods

  static Future<void> schedulePeriodNotification({
    required DateTime scheduledTime,
    required bool areEnabled,
    required int daysBefore,
    required TimeOfDay notificationTime,
  }) async {
    if (!areEnabled) return;

    await _plugin.cancel(_periodNotificationId);

    final notificationDateTime = DateTime(
      scheduledTime.year, scheduledTime.month, scheduledTime.day,
      notificationTime.hour, notificationTime.minute,
    );
    final tzScheduledTime = tz.TZDateTime.from(notificationDateTime, tz.local)
        .subtract(Duration(days: daysBefore));

    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'period_channel', 'Period Predictions',
        importance: Importance.max, priority: Priority.high
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      _periodNotificationId,
      'Period Approaching',
      "Your next period is estimated to start in $daysBefore day${daysBefore > 1 ? 's' : ''}.",
      tzScheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
  
  // Pills

  static Future<void> schedulePillReminder({
    required TimeOfDay reminderTime,
    required bool isEnabled,
  }) async {
    await _plugin.cancel(_pillReminderId);

    if (!isEnabled) return;

    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(reminderTime);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pill_reminder_channel', 'Pill Reminders',
        channelDescription: 'Daily reminders to take your birth control pill',
        importance: Importance.max, priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      _pillReminderId,
      'Pill Reminder',
      "Don't forget to take your pill for today.",
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelPillReminder() async {
    await _plugin.cancel(_pillReminderId);
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Other

  static Future<void> scheduleTamponReminder({required TimeOfDay reminderTime}) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, reminderTime.hour, reminderTime.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'tampon_reminder_channel', 'Tampon Reminders',
        importance: Importance.max, priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(presentSound: true, presentBadge: true, presentAlert: true),
    );

    await _plugin.zonedSchedule(
        _tamponReminderId,
        'Tampon Reminder', 'Remember to change your tampon',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> cancelTamponReminder() async {
    await _plugin.cancel(_tamponReminderId);
  }

  static Future<bool> isTamponReminderScheduled() async {
    final pendingRequests = await _plugin.pendingNotificationRequests();
    return pendingRequests.any((request) => request.id == _tamponReminderId);
  }

  // General

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}