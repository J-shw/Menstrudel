import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_types_enum.dart';

/// The base app seed colour.
const seedColor = Color(0xFF60A5FA);

/// The min days for valid cycle length
const int minValidCycleLength = 10;
/// The max days for valid cycle length - Set high for missed durations.
const int maxValidCycleLength = 130;

// Notification IDs

const int periodDueNotificationId = 1;
const int periodOverdueNotificationId = 4;
const int sanitaryProductsID = 2;
const int pillReminderId = 3;
const int reversibleContraceptiveReminderId = 5;
const int fertileWindowReminderId = 6;
const int ovulationReminderId = 7;

// Notification channels

const periodNotificationChannelId = 'period_channel';
const periodNotificationChannelName = 'Period Predictions';

const sanitaryProductChannelId = 'sanitary_products_reminder_channel';
const sanitaryProductChannelName = 'Sanitary Products Reminders';

const pillReminderChannelId = 'pill_reminder_channel';
const pillReminderChannelName = 'Pill Reminders';

// This ID will have to stay for now. I don't want to change it and cause notification issues for existing users.
const reversibleContraceptivesReminderChannelId = 'larc_reminder_channel';
const reversibleContraceptivesReminderChannelName = 'Reversible Contraceptive Reminders';

const loggingReminderChannelId = 'logging_reminder_channel';
const loggingReminderChannelName = 'Logging Reminders';

const cyclePhaseReminderChannelId = 'cycle_phase_reminder_channel';
const cyclePhaseReminderChannelName = 'Cycle Phase Reminders';


// Shared preferences keys

// Setting Service

// App
const String languageKey = "language";
const String biometricEnabledKey = 'biometric_enabled';
const String dynamicColorKey = 'dynamic_color';
const String themeColorKey = 'theme_color';
const String themeModeKey = 'theme_mode';
const String startingDayOfWeekKey = 'starting_day_of_week';
const String historyViewKey = 'history_view';

// Nav
const String pillNavEnabledKey = "pill_nav_enabled";
const String reversibleContraceptiveNavEnabledKey = "larc_nav_enabled"; // Key will remain the same so existing users dont get unexpected behaviour.
const String sanitaryNavEnabledKey = "sanitary_nav_enabled";
const String sexActivityNavEnabledKey = "sex_activity_nav_enabled";

// User
const String reversibleContraceptiveTypeKey = "larc_type"; // Key will remain the same so existing users dont get unexpected behaviour.
const String defaultSymptomsKey = "default_symptoms";
const String reversibleContraceptiveDurationsKey = "larc_durations"; // Key will remain the same so existing users dont get unexpected behaviour.
const String phasePredictionsKey = "phase_predictions";
const String displayFertileChanceKey = "display_fertile_chance";
const String displayFertileWindowOnCalendarKey = "display_fertile_window_on_calendar";


// Notifications
const String periodDueNotificationsEnabledKey = 'notifications_enabled';
const String loggingReminderKey = 'logging_reminder_notification_enabled';
const String periodOverdueNotificationsEnabledKey = 'period_overdue_notifications_enabled';
const String fertileWindowNotificationsEnabledKey = 'fertile_window_notifications_enabled';
const String ovulationNotificationsEnabledKey = 'ovulation_notifications_enabled';
const String reversibleContraceptiveNotificationsEnabledKey = "larc_notifications_enabled"; // Key will remain the same so existing users dont get unexpected behaviour.

const String notificationDaysKey = 'notification_days';
const String periodOverdueNotificationDaysKey = 'period_overdue_notification_days';
const String reversibleContraceptiveNotificationDaysKey = 'larc_notification_days'; // Key will remain the same so existing users dont get unexpected behaviour.
const String fertileWindowReminderDaysBeforeKey = 'fertile_window_reminder_days_before';
const String ovulationReminderDaysBeforeKey = 'ovulation_reminder_days_before';

const String notificationTimeKey = 'notification_time';
const String periodOverdueNotificationTimeKey = 'period_overdue_notification_time';
const String reversibleContraceptiveNotificationTimeKey = 'larc_notification_time'; // Key will remain the same so existing users dont get unexpected behaviour.
const String loggingReminderTimeKey = 'logging_reminder_notification_time';
const String fertileWindowReminderTimeKey = 'fertile_window_reminder_time';
const String ovulationReminderTimeKey = 'ovulation_reminder_time';


// Notification Service - Currently only sanitary product reminders are stored in the settings service.
const String tamponReminderDateTimeKey = 'tampon_reminder_date_time';

// Shared preferences default values

// Setting Service

// App
const String kDefaultLanguageCode = 'system';
const bool kDefaultBiometricsEnabled = false;
const bool kDefaultDynamicColorEnabled = false;
const Color kDefaultThemeColor = seedColor;
const AppThemeMode kDefaultThemeMode = AppThemeMode.system;
const String kDefaultStartingDayOfWeek = 'monday';
const PeriodHistoryView kDefaultHistoryView = PeriodHistoryView.journal;

// Nav
const bool kDefaultPillNavEnabled = false;
const bool kDefaultReversibleContraceptiveNavEnabled = false;
const bool kDefaultSanitaryNavEnabled = true;
const bool kDefaultSexActivityNavEnabled = false;

// User
const ReversibleContraceptiveTypes kDefaultReversibleContraceptiveType = ReversibleContraceptiveTypes.injection;
const Set<Symptom> kDefaultSymptoms = {};
const bool kDefaultPhasePredictions = true;
const bool kDefaultDisplayFertileChance = true;
const bool kDefaultDisplayFertileWindowOnCalendar = true;

// Notifications
const bool kDefaultPeriodDueNotificationsEnabled = true;
const bool kDefaultPeriodOverdueNotificationsEnabled = false;
const bool kDefaultLoggingReminder = false;
const bool kDefaultFertileWindowNotificationsEnabled = false;
const bool kDefaultOvulationNotificationsEnabled = false;
const bool kDefaultReversibleContraceptiveNotificationsEnabled = false;

const int kDefaultNotificationDays = 1;
const int kDefaultReversibleContraceptiveReminderDays = 30;


const TimeOfDay kDefaultNotificationTime = TimeOfDay(hour: 9, minute: 0);
