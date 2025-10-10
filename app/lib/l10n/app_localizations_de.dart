// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Menstrudel';

  @override
  String get ongoing => 'Fortlaufend';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Zeit';

  @override
  String get start => 'Beginn';

  @override
  String get end => 'Ende';

  @override
  String get day => 'Tag';

  @override
  String get days => 'Tage';

  @override
  String dayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get clear => 'Clear';

  @override
  String get save => 'Speichern';

  @override
  String get import => 'Import';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get set => 'Set';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get select => 'Auswählen';

  @override
  String get close => 'Close';

  @override
  String get flow => 'Flow';

  @override
  String get navBar_insights => 'Einblicke';

  @override
  String get navBar_logs => 'Protokolle';

  @override
  String get navBar_pill => 'Pille';

  @override
  String get navBar_settings => 'Einstellungen';

  @override
  String get flowIntensity_none => 'Keine';

  @override
  String get flowIntensity_spotting => 'Spotting';

  @override
  String get flowIntensity_light => 'Light';

  @override
  String get flowIntensity_moderate => 'Moderate';

  @override
  String get flowIntensity_heavy => 'Heavy';

  @override
  String get symptom_headache => 'Kopfschmerzen';

  @override
  String get symptom_fatigue => 'Fatigue';

  @override
  String get symptom_cramps => 'Krämpfe';

  @override
  String get symptom_nausea => 'Übelkeit';

  @override
  String get symptom_moodSwings => 'Stimmungsschwankungen';

  @override
  String get symptom_bloating => 'Blähungen';

  @override
  String get symptom_acne => 'Akne';

  @override
  String get painLevel_title => 'Schmerzgrad';

  @override
  String get painLevel_none => 'None';

  @override
  String get painLevel_mild => 'Mild';

  @override
  String get painLevel_moderate => 'Moderate';

  @override
  String get painLevel_severe => 'Schwerwiegend';

  @override
  String get pain_unbearable => 'Unerträglich';

  @override
  String get notification_periodTitle => 'Periode nähert sich';

  @override
  String notification_periodBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your next period is estimated to start in $count days.',
      one: 'Your next period is estimated to start in 1 day.',
    );
    return '$_temp0';
  }

  @override
  String get notification_periodOverdueTitle => 'Fälligkeitstag überschritten';

  @override
  String notification_periodOverdueBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your next period is overdue by $count days.',
      one: 'Your next period is overdue by 1 day.',
    );
    return '$_temp0';
  }

  @override
  String get notification_pillTitle => 'Pillenerinnerung';

  @override
  String get notification_pillBody =>
      'Vergiss nicht, Deine Pille für heute einzunehmen.';

  @override
  String get notification_tamponReminderTitle => 'Tampon-Erinnerung';

  @override
  String get notification_tamponReminderBody =>
      'Denk daran, Deinen Tampon zu wechseln.';

  @override
  String get mainScreen_insightsPageTitle => 'Deine Erkenntnisse';

  @override
  String get mainScreen_pillsPageTitle => 'Pills';

  @override
  String get mainScreen_settingsPageTitle => 'Einstellungen';

  @override
  String get mainScreen_tooltipSetReminder => 'Tampon-Erinnerung';

  @override
  String get mainScreen_tooltipCancelReminder => 'Cancel reminder';

  @override
  String get mainScreen_tooltipLogPeriod => 'Log period';

  @override
  String get insightsScreen_errorPrefix => 'Error:';

  @override
  String get insightsScreen_noDataAvailable => 'Keine Daten verfügbar.';

  @override
  String get logsScreen_calculatingPrediction => 'Berechnung der Vorhersage...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Log at least two periods to estimate next cycle.';

  @override
  String get logScreen_nextPeriodEstimate => 'Next period Est';

  @override
  String get logScreen_periodDueToday => 'Period due today';

  @override
  String logScreen_periodOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Period overdue by $count days',
      one: 'Period overdue by 1 day',
    );
    return '$_temp0';
  }

  @override
  String get logScreen_tamponReminderSetFor => 'Tampon reminder set for';

  @override
  String get logScreen_tamponReminderCancelled =>
      'Tampon-Erinnerung abgebrochen.';

  @override
  String get logScreen_couldNotCancelReminder =>
      'Erinnerung konnte nicht abgebrochen werden';

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pill for today marked as taken.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pill for today marked as skipped.';

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
  String get settingsScreen_appearance => 'Aussehen';

  @override
  String get settingsScreen_historyViewStyle => 'History View Style';

  @override
  String get settingsScreen_appTheme => 'App Theme';

  @override
  String get settingsScreen_themeLight => 'Hell';

  @override
  String get settingsScreen_themeDark => 'Dunkel';

  @override
  String get settingsScreen_themeSystem => 'System';

  @override
  String get settingsScreen_dynamicTheme => 'Dynamic Theme';

  @override
  String get settingsScreen_useWallpaperColors => 'Nutze Hintergrundfarben';

  @override
  String get settingsScreen_themeColor => 'Theme Color';

  @override
  String get settingsScreen_pickAColor => 'Eine Farbe auswählen';

  @override
  String get settingsScreen_view => 'View';

  @override
  String get settingsScreen_birthControl => 'Empfängnisverhütung';

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
      'Periodenvorhersage & Erinnerungen';

  @override
  String get settingsScreen_upcomingPeriodReminder =>
      'Erinnerung an die bevorstehende Periode';

  @override
  String get settingsScreen_remindMeBefore => 'Erinnere mich vorher';

  @override
  String get settingsScreen_notificationTime => 'Benachrichtigungszeit';

  @override
  String get settingsScreen_overduePeriodReminder => 'Overdue Period Reminder';

  @override
  String get settingsScreen_remindMeAfter => 'Remind Me After';

  @override
  String get settingsScreen_dataManagement => 'Data Management';

  @override
  String get settingsScreen_clearAllLogs => 'Clear All Logs';

  @override
  String get settingsScreen_clearAllPillData => 'Clear All Pill Data';

  @override
  String get settingsScreen_clearAllPillData_question => 'Clear All Pill Data?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'This will permanently delete your pill regimen, reminders, and intake history. This action cannot be undone.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'All pill data has been cleared.';

  @override
  String get settingsScreen_dangerZone => 'Danger Zone';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Deletes your entire period and symptom history.';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Removes your pill regimen and intake history.';

  @override
  String get settingsScreen_exportPeriodData => 'Export Period Data';

  @override
  String get settingsScreen_exportPillData => 'Export Pill Data';

  @override
  String get settingsScreen_exportDataSubtitle => 'Create a JSON backup file.';

  @override
  String get settingsScreen_exportSuccessful => 'Data exported successfully.';

  @override
  String get settingsScreen_exportFailed => 'Export failed. Please try again.';

  @override
  String get settingsScreen_noDataToExport => 'No data found to export.';

  @override
  String get settingsScreen_exportDataMessage =>
      'Here is my MenstruDel data export.';

  @override
  String get settingsScreen_exportDataTitle => 'Export Data';

  @override
  String get settingsScreen_importDataTitle => 'Import Data';

  @override
  String get settingsScreen_importPeriodData => 'Import Period Data';

  @override
  String get settingsScreen_importPillData => 'Import Pill Data';

  @override
  String get settingsScreen_importDataSubtitle => 'Overwrites existing data.';

  @override
  String get settingsScreen_importPeriodData_question =>
      'Are you sure you want to import Period Data?';

  @override
  String get settingsScreen_importPillData_question =>
      'Are you sure you want to import Pill Data?';

  @override
  String get settingsScreen_importPeriodDataDescription =>
      'Importing data will permanently overwrite all your existing period logs and period settings. This cannot be undone.';

  @override
  String get settingsScreen_importPillDataDescription =>
      'Importing data will permanently overwrite all your existing pill history. This cannot be undone.';

  @override
  String get settingsScreen_importSuccessful => 'Data imported successfully!';

  @override
  String get settingsScreen_importFailed =>
      'Failed to import data. Please try again.';

  @override
  String get settingsScreen_importInvalidFile =>
      'Invalid file format or data structure.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Failed to import data. Please ensure the file is saved locally.';

  @override
  String settingsScreen_importErrorPlatform(String message) {
    return 'Import failed: $message. Please ensure the file is saved on the device and try again.';
  }

  @override
  String get settingsScreen_security => 'Security';

  @override
  String get securityScreen_enableBiometricLock => 'Enable Biometric Lock';

  @override
  String get securityScreen_enableBiometricLockSubtitle =>
      'Require fingerprint or face ID to open the app.';

  @override
  String get securityScreen_noBiometricsAvailable =>
      'No passcode, fingerprint, or face ID found. Please set one up in your device\'s settings.';

  @override
  String get settingsScreen_preferences => 'Preferences';

  @override
  String get preferencesScreen_tamponReminderButton =>
      'Always Show Reminder Button';

  @override
  String get preferencesScreen_tamponReminderButtonSubtitle =>
      'Makes the tampon reminder button permanently visible on the main screen.';

  @override
  String get settingsScreen_about => 'About';

  @override
  String get aboutScreen_version => 'Version';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Source code and issue tracking';

  @override
  String get aboutScreen_share => 'Share';

  @override
  String get aboutScreen_shareSubtitle => 'Share the app with friends';

  @override
  String get aboutScreen_urlError => 'Could not open the link.';

  @override
  String get tamponReminderDialog_tamponReminderTitle => 'Tampon Reminder';

  @override
  String get tamponReminderDialog_tamponReminderMaxDuration =>
      'Max duration is 8 hours.';

  @override
  String get reminderCountdownDialog_title => 'Reminder Due In';

  @override
  String reminderCountdownDialog_dueAt(Object time) {
    return 'Due at $time';
  }

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

  @override
  String get flowIntensityWidget_flowIntensityBreakdown =>
      'Flow Intensity Breakdown';

  @override
  String get flowIntensityWidget_noFlowDataLoggedYet =>
      'No flow data logged yet.';

  @override
  String get painLevelWidget_noPainDataLoggedYet => 'No pain data logged yet.';

  @override
  String get painLevelWidget_painLevelBreakdown => 'Pain Level Breakdown';

  @override
  String get monthlyFlowChartWidget_noDataToDisplay => 'No data to display.';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatterns => 'Cycle Flow Patterns';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription =>
      'Each line represents one complete cycle';

  @override
  String get symptomFrequencyWidget_noSymptomsLoggedYet =>
      'No symptoms logged yet.';

  @override
  String get symptomFrequencyWidget_mostCommonSymptoms =>
      'Most Common Symptoms';

  @override
  String get yearHeatMapWidget_yearlyOverview => 'Yearly Overview';

  @override
  String get journalViewWidget_logYourFirstPeriod => 'Log your first period.';

  @override
  String get listViewWidget_noPeriodsLogged =>
      'No periods logged yet.\nTap the + button to add one.';

  @override
  String get listViewWidget_confirmDelete => 'Confirm Delete';

  @override
  String get listViewWidget_confirmDeleteDescription =>
      'Are you sure you want to delete this entry?';

  @override
  String get emptyPillStateWidget_noPillRegimenFound =>
      'No pill regimen found.';

  @override
  String get emptyPillStateWidget_noPillRegimenFoundDescription =>
      'Set up your pill pack in settings to start tracking.';

  @override
  String get pillPackVisualiser_yourPack => 'Your Pack';

  @override
  String pillStatus_pillsOfTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'of $count pills',
      one: 'of 1 pill',
    );
    return '$_temp0';
  }

  @override
  String get pillStatus_undo => 'Undo';

  @override
  String get pillStatus_skip => 'Skip';

  @override
  String get pillStatus_markAsTaken => 'Mark As Taken';

  @override
  String pillStatus_packStartInFuture(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Your next pill pack starts on $dateString.';
  }

  @override
  String get regimenSetupWidget_setUpPillRegimen => 'Set Up Pill Regimen';

  @override
  String get regimenSetupWidget_packName => 'Pack Name';

  @override
  String get regimenSetupWidget_pleaseEnterAName => 'Please enter a name';

  @override
  String get regimenSetupWidget_activePills => 'Active Pills';

  @override
  String get regimenSetupWidget_enterANumber => 'Enter a number';

  @override
  String get regimenSetupWidget_placeboPills => 'Placebo-Pillen';

  @override
  String get regimenSetupWidget_firstDayOfThisPack => 'First Day of This Pack';

  @override
  String get symptomEntrySheet_logYourDay => 'Log Your Day';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Symptome (optional)';

  @override
  String get periodDetailsSheet_symptoms => 'Symptome';

  @override
  String get periodDetailsSheet_flow => 'Flow';

  @override
  String periodPredictionCircle_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Days',
      one: 'Day',
    );
    return '$_temp0';
  }
}
