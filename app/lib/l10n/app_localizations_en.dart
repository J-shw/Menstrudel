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
  String get nextDue => 'Next Due';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get overdue => 'Overdue';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get day => 'Day';

  @override
  String get days => 'Days';

  @override
  String dayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days',
      one: '$count Day',
    );
    return '$_temp0';
  }

  @override
  String get delete => 'Delete';

  @override
  String get clear => 'Clear';

  @override
  String get save => 'Save';

  @override
  String get import => 'Import';

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
  String get select => 'Select';

  @override
  String get close => 'Close';

  @override
  String get reset => 'Reset';

  @override
  String get add => 'Add';

  @override
  String get notSet => 'Not set';

  @override
  String get note => 'Note';

  @override
  String get systemDefault => 'System Default';

  @override
  String get flow => 'Flow';

  @override
  String get navBar_insights => 'Insights';

  @override
  String get navBar_logs => 'Logs';

  @override
  String get navBar_pill => 'Pill';

  @override
  String get navBar_larc => 'LARC';

  @override
  String get navBar_settings => 'Settings';

  @override
  String get flowIntensity_none => 'None';

  @override
  String get flowIntensity_spotting => 'Spotting';

  @override
  String get flowIntensity_light => 'Light';

  @override
  String get flowIntensity_moderate => 'Moderate';

  @override
  String get flowIntensity_heavy => 'Heavy';

  @override
  String get builtInSymptom_acne => 'Acne';

  @override
  String get builtInSymptom_backPain => 'Back pain';

  @override
  String get builtInSymptom_bloating => 'Bloating';

  @override
  String get builtInSymptom_cramps => 'Cramps';

  @override
  String get builtInSymptom_fatigue => 'Fatigue';

  @override
  String get builtInSymptom_headache => 'Headache';

  @override
  String get builtInSymptom_moodSwings => 'Mood swings';

  @override
  String get builtInSymptom_nausea => 'Nausea';

  @override
  String get painLevel_title => 'Pain Level';

  @override
  String get painLevel_none => 'None';

  @override
  String get painLevel_mild => 'Mild';

  @override
  String get painLevel_moderate => 'Moderate';

  @override
  String get painLevel_severe => 'Severe';

  @override
  String get pain_unbearable => 'Unbearable';

  @override
  String get larcType_iud => 'IUD';

  @override
  String get larcType_implant => 'Implant';

  @override
  String get larcType_injection => 'Injection';

  @override
  String get larcType_ring => 'Ring';

  @override
  String get larcType_patch => 'Patch';

  @override
  String get notification_periodTitle => 'Period Approaching';

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
  String get notification_periodOverdueTitle => 'Period Overdue';

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
  String get notification_pillTitle => 'Pill Reminder';

  @override
  String get notification_pillBody =>
      'Don\'t forget to take your pill for today.';

  @override
  String get notification_tamponReminderTitle => 'Tampon Reminder';

  @override
  String get notification_tamponReminderBody =>
      'Remember to change your tampon.';

  @override
  String get mainScreen_insightsPageTitle => 'Your Insights';

  @override
  String get mainScreen_pillsPageTitle => 'Pills';

  @override
  String get mainScreen_LarcsPageTitle => 'LARCs';

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
  String get logScreen_tamponReminderCancelled => 'Tampon reminder cancelled.';

  @override
  String get logScreen_couldNotCancelReminder => 'Could not cancel reminder';

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pill for today marked as taken.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pill for today marked as skipped.';

  @override
  String get larcScreen_noLarcRecordsFound => 'No LARC records found.';

  @override
  String larcScreen_history(int history) {
    return 'History ($history)';
  }

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
  String get settingsScreen_appTheme => 'App Theme';

  @override
  String get settingsScreen_themeLight => 'Light';

  @override
  String get settingsScreen_themeDark => 'Dark';

  @override
  String get settingsScreen_themeSystem => 'System';

  @override
  String get settingsScreen_dynamicTheme => 'Dynamic Theme';

  @override
  String get settingsScreen_useWallpaperColors => 'Use Wallpaper Colors';

  @override
  String get settingsScreen_themeColor => 'Theme Color';

  @override
  String get settingsScreen_pickAColor => 'Pick a Color';

  @override
  String get settingsScreen_view => 'View';

  @override
  String get settingsScreen_birthControl => 'Birth Control';

  @override
  String get settingsScreen_enablePillTracking => 'Enable Pill Tracking';

  @override
  String get settingsScreen_pillDescription =>
      'Track your daily pill intake and get reminders.';

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
  String get settingsScreen_overduePeriodReminder => 'Overdue Period Reminder';

  @override
  String get settingsScreen_remindMeAfter => 'Remind Me After';

  @override
  String get settingsScreen_enableLarcTracking => 'Enable LARC Tracking';

  @override
  String get settingsScreen_larcDescription =>
      'Track long-acting reversible contraceptives (LARCs).';

  @override
  String get settingsScreen_larcType => 'LARC Type';

  @override
  String get settingsScreen_LoggingScreen => 'Logging';

  @override
  String get settingsScreen_defaultSymptoms => 'Default Symptoms';

  @override
  String get settingsScreen_defaultSymptomsSubtitle =>
      'These are always available when logging new periods.\nTap an existing symptom to delete or \'+\' to add a new one.';

  @override
  String settingsScreen_deleteDefaultSymptomQuestion(String symptom) {
    return 'Delete \'$symptom\'?';
  }

  @override
  String get settingsScreen_resetSymptomsList => 'Reset Symptoms List?';

  @override
  String get settingsScreen_resetSymptomsListDescription =>
      'This will remove all your custom symptoms and restore the original built-in list.\n\nYour existing log entries will not be changed.';

  @override
  String settingsScreen_deleteDefaultSymptomDescription(
    String symptom,
    num usageCount,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      usageCount,
      locale: localeName,
      other:
          'There are $usageCount period logs with this symptom!\nThese logs will not be changed.',
      one:
          'There is already 1 period log with this symptom!\nThis log will not be changed.',
      zero: 'There are currently no period logs with this symptom!',
    );
    return '\'$symptom\' will no longer be available when logging a period.\n\n$_temp0';
  }

  @override
  String get settingsScreen_pillRegimens => 'Pill Regimens';

  @override
  String get settingsScreen_makeActive => 'Set as Active';

  @override
  String get settingsScreen_activeRegimenReminder =>
      'Active Regimen Reminder Settings';

  @override
  String get settingsScreen_pack => 'Pack';

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
  String get preferencesScreen_language => 'Language';

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
  String get regimenSetupWidget_placeboPills => 'Placebo Pills';

  @override
  String get regimenSetupWidget_firstDayOfThisPack => 'First Day of This Pack';

  @override
  String get symptomEntrySheet_logYourDay => 'Log Your Day';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Symptoms (Optional)';

  @override
  String get periodDetailsSheet_symptoms => 'Symptoms';

  @override
  String get periodDetailsSheet_flow => 'Flow';

  @override
  String get larcEntrySheet_logLARCDetails => 'Log LARC Details';

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

  @override
  String get customSymptomDialog_newSymptom => 'New Symptom';

  @override
  String get customSymptomDialog_enterCustomSymptom => 'Enter a custom symptom';

  @override
  String get customSymptomDialog_temporarySymptom => 'Temporary Symptom';
}
