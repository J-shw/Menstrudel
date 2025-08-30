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
  String get logScreen_days => 'days';

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
  String get navBar_insights => 'Insights';

  @override
  String get navBar_logs => 'Logs';

  @override
  String get navBar_pill => 'Pill';

  @override
  String get navBar_settings => 'Settings';
}
