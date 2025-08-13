import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const int tamponNotificationId = 2; 

Future<void> tamponNotificationScheduler({required TimeOfDay reminderTime}) async {
  final now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    reminderTime.hour,
    reminderTime.minute,
  );

  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'tampon_reminder_channel',
    'Tampon Reminders',
    channelDescription: 'One-time reminders to change tampons.',
    importance: Importance.max,
    priority: Priority.high,
  );
  const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    tamponNotificationId,
    'Tampon Reminder',
    'Remember to change your tampon',
    scheduledDate,
    platformDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}