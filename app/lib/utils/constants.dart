import 'package:flutter/material.dart';

/// The base app seed colour.
const seedColor = Color(0xFF60A5FA);

/// The min days for valid cycle length
const int minValidCycleLength = 10;
/// The max days for valid cycle length - Set high for missed durations.
const int maxValidCycleLength = 130;

const int periodDueNotificationId = 1;
const int periodOverdueNotificationId = 4;
const int tamponReminderId = 2;
const int pillReminderId = 3;

const periodNotificationChannelId = 'period_channel';
const periodNotificationChannelName = 'Period Predictions';

const tamponReminderChannelId = 'tampon_reminder_channel';
const tamponReminderChannelName = 'Tampon Reminders';

const pillReminderChannelId = 'pill_reminder_channel';
const pillReminderChannelName = 'Pill Reminders';

// Shared preferences keys

// Settings
const String notificationsEnabledKey = 'notifications_enabled';
const String notificationDaysKey = 'notification_days';
const String notificationTimeKey = 'notification_time';
const String periodOverdueNotificationsEnabledKey = 'period_overdue_notifications_enabled';
const String periodOverdueNotificationDaysKey = 'period_overdue_notification_days';
const String periodOverdueNotificationTimeKey = 'period_overdue_notification_time';
const String biometricEnabledKey = 'biometric_enabled';
const String historyViewKey = 'history_view';
const String dynamicColorKey = 'dynamic_color';
const String themeColorKey = 'theme_color';
const String themeModeKey = 'theme_mode';
const String persistentReminderKey = "always_show_reminder_button";
const String defaultSymptomsKey = "default_symptoms";
const String languageKey = "language";

// Notifications
const String tamponReminderDateTimeKey = 'tampon_reminder_date_time';