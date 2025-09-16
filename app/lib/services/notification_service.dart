import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import 'package:menstrudel/utils/constants.dart';
import 'package:menstrudel/utils/exceptions.dart';

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(fln.NotificationResponse notificationResponse) {
  debugPrint('Notification tapped: ${notificationResponse.payload}');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(fln.NotificationResponse notificationResponse) {
  debugPrint('Background notification tapped: ${notificationResponse.payload}');
}

class NotificationService {
  static final fln.FlutterLocalNotificationsPlugin _plugin = fln.FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = fln.DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = fln.InitializationSettings(android: androidSettings, iOS: iOSSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<fln.AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Perdiods

  /// Schedules notifications related to periods
  static Future<void> schedulePeriodNotifications({
    required DateTime scheduledTime,
    required bool areEnabled,
    required TimeOfDay notificationTime,
    required String title,
    required String body,
    required int notificationID,
    int? daysBefore,
    int? daysAfter,
  }) async {

    if (!areEnabled) return;

    if(daysBefore != null || daysAfter != null){
      debugPrint("daysBefore or daysAfter are required.");
      return;
    }

    final notificationDateTime = DateTime(
      scheduledTime.year, scheduledTime.month, scheduledTime.day,
      notificationTime.hour, notificationTime.minute,
    );

    tz.TZDateTime? tzScheduledTime;

    if (daysBefore != null) {
      tzScheduledTime = tz.TZDateTime.from(notificationDateTime, tz.local)
        .subtract(Duration(days: daysBefore));
    }
    if (daysAfter != null) {
      tzScheduledTime = tz.TZDateTime.from(notificationDateTime, tz.local)
        .subtract(Duration(days: daysAfter));
    }
    if (tzScheduledTime == null) return;

    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) throw PastNotificationException();

    await _plugin.cancel(notificationID);

    const details = fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        periodNotificationChannelId, periodNotificationChannelName,
        importance: fln.Importance.max, priority: fln.Priority.high
      ),
      iOS: fln.DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      notificationID,
      title,
      body,
      tzScheduledTime,
      details,
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
  
  // Pills

  static Future<void> schedulePillReminder({
    required TimeOfDay reminderTime,
    required bool isEnabled,
    required String title,
    required String body, 
  }) async {
    await _plugin.cancel(pillReminderId);

    if (!isEnabled) return;

    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(reminderTime);

    const details = fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        pillReminderChannelId, pillReminderChannelName,
        channelDescription: 'Daily reminders to take your birth control pill',
        importance: fln.Importance.max, priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      pillReminderId,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: fln.DateTimeComponents.time,
    );
  }

  static Future<void> cancelPillReminder() async {
    await _plugin.cancel(pillReminderId);
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

  static Future<void> scheduleTamponReminder({
    required TimeOfDay reminderTime,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, reminderTime.hour, reminderTime.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const details = fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        tamponReminderChannelId, tamponReminderChannelName,
        importance: fln.Importance.max, priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(presentSound: true, presentBadge: true, presentAlert: true),
    );

    await _plugin.zonedSchedule(
        tamponReminderId,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> cancelTamponReminder() async {
    await _plugin.cancel(tamponReminderId);
  }

  static Future<bool> isTamponReminderScheduled() async {
    final pendingRequests = await _plugin.pendingNotificationRequests();
    return pendingRequests.any((request) => request.id == tamponReminderId);
  }

  // General

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}