import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:shared_preferences/shared_preferences.dart';
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
    const androidSettings = fln.AndroidInitializationSettings('@drawable/ic_launcher_monochrome');
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

    if(daysBefore != null && daysAfter != null){
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
    else if (daysAfter != null) {
      tzScheduledTime = tz.TZDateTime.from(notificationDateTime, tz.local)
        .add(Duration(days: daysAfter));
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

  // Phase notifications

  static Future<void> scheduleFertileWindowNotification({
    required DateTime scheduledTime,
    required TimeOfDay notificationTime,
    required String title,
    required String body,
    required int notificationID,
    int? daysBefore,
  }) async {

    if(daysBefore != null){
      debugPrint("daysBefore is required.");
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

  static Future<void> cancelFertileWindowNotification() async {
    debugPrint('Canceling fertile window notification reminder');
    await _plugin.cancel(fertileWindowReminderId);
  }

  // Logging reminders

  static int _generateLoggingReminderIdFromScheduledDate(DateTime scheduledDate) {
    final logDate = scheduledDate.subtract(const Duration(days: 1));
    final date = DateUtils.dateOnly(logDate);
    
    const int loggingReminderIdStart = 200000;
    return loggingReminderIdStart + 
          date.year * 10000 + 
          date.month * 100 + 
          date.day;
  }

  static Future<void> scheduleLoggingReminder({
    required DateTime scheduledTime,
    required bool isEnabled,
    required String title,
    required String body,
  }) async {
    if (!isEnabled) return;

    if (scheduledTime.isBefore(DateTime.now())){
      debugPrint('Scheduled time is in the past.');
      return;
    };

    final int reminderId = _generateLoggingReminderIdFromScheduledDate(scheduledTime);
    debugPrint('Scheduling logging reminder with ID: $reminderId');
    
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    const details = fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        loggingReminderChannelId, loggingReminderChannelName,
        channelDescription: 'Logging reminders',
        importance: fln.Importance.max, priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      reminderId,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelLoggingReminder(DateTime logDate) async {
    final scheduledDate = logDate.add(const Duration(days: 1));
    final int reminderId = _generateLoggingReminderIdFromScheduledDate(scheduledDate);
    
    await _plugin.cancel(reminderId);
    debugPrint('Canceled logging reminder associated with log date: ${logDate.toIso8601String()} (ID: $reminderId)');
  }

  // Pills

  /// This will tell the system to send a notification at this time everyday. 
  /// The app should then tell this to stop if either:
  /// - User logs a pill intake
  /// - User disables the pill reminder
  /// startingTomorrow does not work yet :/
  static Future<void> schedulePillReminder({
    required TimeOfDay reminderTime,
    required bool isEnabled,
    required String title,
    required String body,
    bool startingTomorrow = false,
  }) async {
    if (startingTomorrow){
      debugPrint('Scheduling pill reminder for tomorrow');
    }else{
      debugPrint('Scheduling pill reminder');
    }
    await _plugin.cancel(pillReminderId);

    if (!isEnabled) return;

    final tz.TZDateTime scheduledDate = _nextInstanceOfTime(reminderTime, startingTomorrow);

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
    debugPrint('Canceling pill reminder');
    await _plugin.cancel(pillReminderId);
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time, bool startingTomorrow) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    
    if (scheduledDate.isBefore(now) || startingTomorrow) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Sanitary Product Reminders

  static Future<void> scheduleSanitaryProductReminder({
    required DateTime reminderDateTime,
    required String title,
    required String body,
  }) async {
    final scheduledDate = tz.TZDateTime.from(reminderDateTime, tz.local);

    const details = fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        sanitaryProductChannelId, sanitaryProductChannelName,
        importance: fln.Importance.max, priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(presentSound: true, presentBadge: true, presentAlert: true),
    );

    await _plugin.zonedSchedule(
        sanitaryProductsID,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> cancelSanitaryProductReminder() async {
    await _plugin.cancel(sanitaryProductsID);
  }

  static Future<bool> isSanitaryProductReminderScheduled() async {
    final pendingRequests = await _plugin.pendingNotificationRequests();
    return pendingRequests.any((request) => request.id == sanitaryProductsID);
  }

  /// Saves the date and time for when the tampon reminder is scheduled
  static Future<void> setSanitaryProductReminderScheduledTime(DateTime scheduledDateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(tamponReminderDateTimeKey, scheduledDateTime.millisecondsSinceEpoch);
  }

  /// Gets the date and time for when the tampon reminder is scheduled
  static Future<DateTime?> getSanitaryProductReminderScheduledTime() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTimestamp = prefs.getInt(tamponReminderDateTimeKey);

    if (storedTimestamp == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(storedTimestamp);
  }

  // Reversible Contraceptives

  static Future<void> scheduleReversibleContraceptiveReminder({
    required DateTime reminderDateTime,
    required String title,
    required String body,
  }) async {
    final scheduledDate = tz.TZDateTime.from(reminderDateTime, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) throw PastNotificationException();

    debugPrint('Scheduling reverible contraceptive reminder');

    const details = fln.NotificationDetails(
      android: fln.AndroidNotificationDetails(
        reversibleContraceptivesReminderChannelId, reversibleContraceptivesReminderChannelName,
        importance: fln.Importance.max, priority: fln.Priority.high,
      ),
      iOS: fln.DarwinNotificationDetails(presentSound: true, presentBadge: true, presentAlert: true),
    );

    await _plugin.zonedSchedule(
        reversibleContraceptiveReminderId,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> cancelReversibleContraceptiveReminder() async {
    debugPrint('Canceling reverisble contraceptive reminder');
    await _plugin.cancel(reversibleContraceptiveReminderId);
  }


  // General

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}