import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_types_enum.dart';

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
const int larcReminderId = 5;

const periodNotificationChannelId = 'period_channel';
const periodNotificationChannelName = 'Period Predictions';

const tamponReminderChannelId = 'tampon_reminder_channel';
const tamponReminderChannelName = 'Tampon Reminders';

const pillReminderChannelId = 'pill_reminder_channel';
const pillReminderChannelName = 'Pill Reminders';

const larcReminderChannelId = 'larc_reminder_channel';
const larcReminderChannelName = 'LARC Reminders';


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
const String pillNavEnabledKey = "pill_nav_enabled";
const String larcNavEnabledKey = "larc_nav_enabled";
const String larcTypeKey = "larc_type";
const String larcDurationsKey = "larc_durations";
const String larcNotificationsEnanledKey = "larc_notifications_enabled";
const String larcNotificationDaysKey = 'larc_notification_days';
const String larcNotificationTimeKey = 'larc_notification_time';

// Notifications
const String tamponReminderDateTimeKey = 'tampon_reminder_date_time';

// Shared preferences default values

// Settings
const bool kDefaultPillNavEnabled = false;
const bool kDefaultLarcNavEnabled = false;
const LarcTypes kDefaultLarcType = LarcTypes.injection;
const String kDefaultLanguageCode = 'system';
const bool kDefaultAlwaysShowReminderButton = false;
const bool kDefaultBiometricsEnabled = false;
const bool kDefaultNotificationsEnabled = true;
const int kDefaultNotificationDays = 1;
const TimeOfDay kDefaultNotificationTime = TimeOfDay(hour: 9, minute: 0);
const bool kDefaultPeriodOverdueNotificationsEnabled = true;
const int kDefaultPeriodOverdueNotificationDays = 1;
const TimeOfDay kDefaultPeriodOverdueNotificationTime = TimeOfDay(hour: 9, minute: 0);
const PeriodHistoryView kDefaultHistoryView = PeriodHistoryView.journal;
const bool kDefaultDynamicColorEnabled = false;
const Color kDefaultThemeColor = seedColor;
const AppThemeMode kDefaultThemeMode = AppThemeMode.system;
const Set<Symptom> kDefaultSymptoms = {};
const bool kDefaultLarcNotificationsEnabled = false;
const int kDefaultLarcReminderDays = 30;
const TimeOfDay kDefaultLarcReminderTime = TimeOfDay(hour: 9, minute: 0);