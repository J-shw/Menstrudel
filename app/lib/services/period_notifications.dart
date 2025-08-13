import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
  debugPrint('Notification tapped: ${notificationResponse.payload}');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
  debugPrint('Background notification tapped: ${notificationResponse.payload}');
}

class NotificationHelper {
  static const int periodNotificationId = 1;
  final SettingsService _settingsService = SettingsService();

  static Future<void> initialiseNotifications() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/London'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> schedulePeriodNotification({ // Schedules a notification
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final bool areEnabled = await _settingsService.areNotificationsEnabled();
    final int daysBefore = await _settingsService.getNotificationDays();
    if (areEnabled) {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'scheduled_channel_id',
        'Period Alerts',
        channelDescription: 'Prediction alerts for periods',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );
      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      final notificationTimeAt9AM = DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day, 9);
      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(notificationTimeAt9AM, tz.local).subtract(Duration(days: daysBefore));


      if (tzScheduledTime.isAfter(tz.TZDateTime.now(tz.local))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          periodNotificationId,
          "Period Reminder",
          "Your period is due tomorrow",
          tzScheduledTime,
          platformDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      }
    }
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}