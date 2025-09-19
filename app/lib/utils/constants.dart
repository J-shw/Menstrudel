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