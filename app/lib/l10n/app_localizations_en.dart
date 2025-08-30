// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Menstrudel';

  @override
  String get day => 'Day';

  @override
  String get days => 'Days';

  @override
  String get delete => 'Delete';

  @override
  String get clear => 'Clear';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get set => 'Set';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get cancel => 'Cancel';

  @override
  String get navBar_insights => 'Insights';

  @override
  String get navBar_logs => 'Logs';

  @override
  String get navBar_pill => 'Pill';

  @override
  String get navBar_settings => 'Settings';

  @override
  String get mainScreen_insightsPageTitle => 'Your Insights';

  @override
  String get mainScreen_pillsPageTitle => 'Pills';

  @override
  String get mainScreen_settingsPageTitle => 'Settings';

  @override
  String get mainScreen_tooltipSetReminder => 'Tampon reminder';

  @override
  String get mainScreen_tooltipCancelReminder => 'Cancel reminder';

  @override
  String get mainScreen_tooltipLogPeriod => 'Log period';

  @override
  String get insightsScreen_errorPrefix => 'Error:';

  @override
  String get insightsScreen_noDataAvailable => 'No data available.';

  @override
  String get logsScreen_calculatingPrediction => 'Calculating prediction...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Log at least two periods to estimate next cycle.';

  @override
  String get logScreen_nextPeriodEstimate => 'Next period Est';

  @override
  String get logScreen_periodDueToday => 'Period due today';

  @override
  String get logScreen_periodOverdueBy => 'Period overdue by';

  @override
  String get logScreen_tamponReminderSetFor => 'Tampon reminder set for';

  @override
  String get logScreen_tamponReminderCancelled => 'Tampon reminder cancelled.';

  @override
  String get logScreen_couldNotCancelReminder => 'Could not cancel reminder';

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pill for today marked as taken!';

  @override
  String get settingsScreen_selectHistoryView => 'Select History View';

  @override
  String get settingsScreen_deleteRegimen_question => 'Delete Regimen?';

  @override
  String get settingsScreen_deleteRegimenDescription =>
      'This will delete your current pill pack settings and all associated pill logs. This cannot be undone.';

  @override
  String get settingsScreen_allLogsHaveBeenCleared =>
      'All logs have been cleared.';

  @override
  String get settingsScreen_clearAllLogs_question => 'Clear All Logs?';

  @override
  String get settingsScreen_deleteAllLogsDescription =>
      'This will permanently delete all your period logs. Your app settings will not be affected.';

  @override
  String get settingsScreen_appearance => 'Appearance';

  @override
  String get settingsScreen_historyViewStyle => 'History View Style';

  @override
  String get settingsScreen_view => 'View';

  @override
  String get settingsScreen_birthControl => 'Birth Control';

  @override
  String get settingsScreen_setUpPillRegimen => 'Set Up Pill Regimen';

  @override
  String get settingsScreen_trackYourDailyPillIntake =>
      'Track Your Daily Pill Intake';

  @override
  String get settingsScreen_dailyPillReminder => 'Daily Pill Reminder';

  @override
  String get settingsScreen_reminderTime => 'Reminder Time';

  @override
  String get settingsScreen_periodPredictionAndReminders =>
      'Period Prediction & Reminders';

  @override
  String get settingsScreen_upcomingPeriodReminder =>
      'Upcoming Period Reminder';

  @override
  String get settingsScreen_remindMeBefore => 'Remind Me Before';

  @override
  String get settingsScreen_notificationTime => 'Notification Time';

  @override
  String get settingsScreen_clearAllLogs => 'Clear All Logs';

  @override
  String get tamponReminderDialog_tamponReminderTitle => 'Tampon Reminder';

  @override
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods =>
      'Need at least two cycles to show variance.';

  @override
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance =>
      'Cycle & Period Variance';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Average Cycle';

  @override
  String get cycleLengthVarianceWidget_averagePeriod => 'Average Period';

  @override
  String get cycleLengthVarianceWidget_period => 'Period';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Cycle';
}
