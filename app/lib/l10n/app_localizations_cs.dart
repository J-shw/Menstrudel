// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Menstrundel';

  @override
  String get nextDue => 'další termín';

  @override
  String get ongoing => 'probíhající';

  @override
  String get overdue => 'zpožděný';

  @override
  String get total => 'celkově';

  @override
  String get shortest => 'nejkratší';

  @override
  String get longest => 'nejdelší';

  @override
  String get date => 'datum';

  @override
  String get time => 'čas';

  @override
  String get start => 'začátek';

  @override
  String get end => 'konec';

  @override
  String get day => 'den';

  @override
  String get days => 'dny';

  @override
  String get hours => 'hodiny';

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
  String monthCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Months',
      one: '$count Month',
    );
    return '$_temp0';
  }

  @override
  String yearCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Years',
      one: '$count Year',
    );
    return '$_temp0';
  }

  @override
  String get logs => 'Logs';

  @override
  String get insights => 'Insights';

  @override
  String get edit => 'upravit';

  @override
  String get delete => 'smazat';

  @override
  String get clear => 'vyčistit';

  @override
  String get save => 'uložit';

  @override
  String get import => 'importovat';

  @override
  String get ok => 'ok';

  @override
  String get confirm => 'potvrdit';

  @override
  String get set => 'nastavit';

  @override
  String get yes => 'ano';

  @override
  String get no => 'ne';

  @override
  String get cancel => 'zrušit';

  @override
  String get select => 'vybrat';

  @override
  String get close => 'zavřít';

  @override
  String get reset => 'restartovat';

  @override
  String get add => 'přidat';

  @override
  String get notSet => 'nenastavené';

  @override
  String get removed => 'smazáno';

  @override
  String get note => 'poznámka';

  @override
  String get systemDefault => 'podle systému';

  @override
  String get flow => 'tok';

  @override
  String get type => 'typ';

  @override
  String get navBar_insights => 'Statistiky';

  @override
  String get navBar_logs => 'Záznamy';

  @override
  String get navBar_sanitary => 'Pomůcky';

  @override
  String get navBar_pill => 'Pilulky';

  @override
  String get navBar_larc => 'DPRA';

  @override
  String get navBar_settings => 'Nastavení';

  @override
  String get flowIntensity_none => 'žádná';

  @override
  String get flowIntensity_spotting => 'špinění';

  @override
  String get flowIntensity_light => 'lehké';

  @override
  String get flowIntensity_moderate => 'střední';

  @override
  String get flowIntensity_heavy => 'vysoké';

  @override
  String get builtInSymptom_acne => 'akné';

  @override
  String get builtInSymptom_backPain => 'Bolest zad';

  @override
  String get builtInSymptom_bloating => 'Nadýmání';

  @override
  String get builtInSymptom_cramps => 'Bolesti';

  @override
  String get builtInSymptom_fatigue => 'Závratě';

  @override
  String get builtInSymptom_headache => 'Bolest hlavy';

  @override
  String get builtInSymptom_moodSwings => 'Změny nálad';

  @override
  String get builtInSymptom_nausea => 'Nevolnost';

  @override
  String get painLevel_title => 'Intenzita bolesti';

  @override
  String get painLevel_none => 'žádný';

  @override
  String get painLevel_mild => 'lehký';

  @override
  String get painLevel_moderate => 'střední';

  @override
  String get painLevel_severe => 'bolestivý';

  @override
  String get pain_unbearable => 'nesnesitelné';

  @override
  String get larcType_iud => 'nitroděložní tělísko';

  @override
  String get larcType_implant => 'implantát';

  @override
  String get larcType_injection => 'injekce';

  @override
  String get larcType_ring => 'vaginální kroužek';

  @override
  String get larcType_patch => 'náplast';

  @override
  String get sanitaryProduct_tampon => 'tampon';

  @override
  String get sanitaryProduct_pad => 'vložka';

  @override
  String get sanitaryProduct_menstrualCup => 'menstruační kalíšek';

  @override
  String get sanitaryProduct_periodUnderwear => 'menstruační kalhotky';

  @override
  String get error_valueMustbePositive => 'hodnota musí být kladná';

  @override
  String get error_valueCannotBeNull => 'hodnota nesmí být prázdná';

  @override
  String get notification_periodTitle => 'blížící se menstruace';

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
  String get notification_periodOverdueTitle => 'opožděná menstruace';

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
  String get notification_pillTitle => 'připomenutí pilulky';

  @override
  String get notification_pillBody => 'Nezapomeňte si dnes vzít pilulky!';

  @override
  String get notification_larcTitle => 'Upomínka DPRA';

  @override
  String notification_larcBody(String type, int days) {
    return '.';
  }

  @override
  String get notification_loggingReminderTitle => 'Logging Reminder';

  @override
  String get notification_loggingReminderBody =>
      'Tap to log your flow for today.';

  @override
  String get notification_SanitaryProductReminderTitle =>
      'Sanitary Product Reminder';

  @override
  String get notification_SanitaryProductReminderBody =>
      'Remember to change your product.';

  @override
  String get mainScreen_insightsPageTitle => 'Your Insights';

  @override
  String get mainScreen_sanitaryPageTitle => 'Sanitary Products';

  @override
  String get mainScreen_pillsPageTitle => 'Pills';

  @override
  String get mainScreen_LarcsPageTitle => 'LARCs';

  @override
  String get mainScreen_settingsPageTitle => 'Settings';

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
  String larcScreen_activeLarcs(int activeCount) {
    return 'Active LARCs ($activeCount)';
  }

  @override
  String get larcScreen_activeLarcsDescription =>
      'Currently monitored LARC entries.';

  @override
  String get larcScreen_noActiveRecords =>
      'No LARC is currently active. Please log a new entry.';

  @override
  String get larcScreen_noHistoryRecords =>
      'No past or overdue LARC records found.';

  @override
  String get sanitaryProductsScreen_noSanitaryProductRecordsFound =>
      'No sanitary product records found.';

  @override
  String sanitaryProductsScreen_history(int history) {
    return 'History ($history)';
  }

  @override
  String get sanitaryProductsScreen_noHistoryRecords =>
      'No past sanitary product records found.';

  @override
  String sanitaryProductsScreen_activeProduct(String activeType) {
    return 'Active $activeType';
  }

  @override
  String sanitaryProductsScreen_changeDueAt(String time) {
    return 'Change Due At $time';
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
  String get settingsScreen_setDuration => 'Set Duration';

  @override
  String get settingsScreen_larcDuration => 'LARC Replacement Duration';

  @override
  String get settingsScreen_enableLARCReminder => 'Enable LARC Reminder';

  @override
  String get settingsScreen_currentDuration => 'Current Duration';

  @override
  String get settingsScreen_durationInDays => 'Duration (Days)';

  @override
  String get settingsScreen_LoggingScreen => 'Logging';

  @override
  String get settingsScreen_enableLoggingReminders =>
      'Enable Logging Reminders';

  @override
  String get settingsScreen_loggingReminderDescription =>
      'If you log a day with flow, you will receive a notification the following day to log your status.';

  @override
  String get settingsScreen_loggingReminderTime => 'Logging Reminder Time';

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
  String get settingsScreen_dangerZone => 'Danger Zone';

  @override
  String get settingsScreen_clearAllLogs => 'Clear All Logs';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Deletes your entire period and symptom history.';

  @override
  String get settingsScreen_clearAllPillData => 'Clear All Pill Data';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Removes your pill regimen and intake history.';

  @override
  String get settingsScreen_clearAllPillData_question => 'Clear All Pill Data?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'This will permanently delete your pill regimen, reminders, and intake history.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'All pill data has been cleared.';

  @override
  String get settingsScreen_clearAllLarcData => 'Clear All LARC Data';

  @override
  String get settingsScreen_clearAllLarcDataSubtitle =>
      'Removes your LARCs history.';

  @override
  String get settingsScreen_clearAllLarcData_question => 'Clear All LARC Data?';

  @override
  String get settingsScreen_deleteAllLarcDataDescription =>
      'This will permanently delete your LARC history.';

  @override
  String get settingsScreen_allLarcDataCleared =>
      'All LARC data has been cleared.';

  @override
  String get settingsScreen_clearAllSanitaryData =>
      'Clear All Sanitary Products Data';

  @override
  String get settingsScreen_clearAllSanitaryDataSubtitle =>
      'Removes your sanitary products history.';

  @override
  String get settingsScreen_clearAllSanitaryData_question =>
      'Clear All Sanitary Products Data?';

  @override
  String get settingsScreen_deleteAllSanitaryDataDescription =>
      'This will permanently delete your sanitary products history.';

  @override
  String get settingsScreen_allSanitaryDataCleared =>
      'All sanitary products data has been cleared.';

  @override
  String get settingsScreen_exportPeriodData => 'Export Period Data';

  @override
  String get settingsScreen_exportPillData => 'Export Pill Data';

  @override
  String get settingsScreen_exportLarcsData => 'Export LARCs Data';

  @override
  String get settingsScreen_exportSanitaryData =>
      'Export Sanitary Products Data';

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
  String get settingsScreen_importLarcsData => 'Import LARCs Data';

  @override
  String get settingsScreen_importSanitaryData =>
      'Import Sanitary Products Data';

  @override
  String get settingsScreen_importDataSubtitle => 'Overwrites existing data.';

  @override
  String get settingsScreen_importPeriodData_question =>
      'Are you sure you want to import Period Data?';

  @override
  String get settingsScreen_importPillData_question =>
      'Are you sure you want to import Pill Data?';

  @override
  String get settingsScreen_importLarcData_question =>
      'Are you sure you want to import LARC Data?';

  @override
  String get settingsScreen_importSanitaryData_question =>
      'Are you sure you want to import Sanitary Products Data?';

  @override
  String get settingsScreen_importPeriodDataDescription =>
      'Importing data will permanently overwrite all your existing period logs and period settings. This cannot be undone.';

  @override
  String get settingsScreen_importPillDataDescription =>
      'Importing data will permanently overwrite all your existing pill history. This cannot be undone.';

  @override
  String get settingsScreen_importLarcDataDescription =>
      'Importing data will permanently overwrite all your existing LARC history. This cannot be undone.';

  @override
  String get settingsScreen_importSanitaryDataDescription =>
      'Importing data will permanently overwrite all your existing sanitary product history. This cannot be undone.';

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
  String get preferencesScreen_enableSanitaryProductsScreen =>
      'Enable Sanitary Products Screen';

  @override
  String get preferencesScreen_enableSanitaryProductsScreenSubtitle =>
      'Show the Sanitary Products tab on the main navigation bar.';

  @override
  String get settingsScreen_about => 'About';

  @override
  String get aboutScreen_version => 'Version';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Source code and issue tracking';

  @override
  String get aboutScreen_discord => 'Discord';

  @override
  String get aboutScreen_discordSubtitle => 'Support and community';

  @override
  String get aboutScreen_share => 'Share';

  @override
  String get aboutScreen_shareSubtitle => 'Share the app with friends';

  @override
  String get aboutScreen_urlError => 'Could not open the link.';

  @override
  String get logSummaryWidget_loggedDays => 'Logged Days';

  @override
  String get logSummaryWidget_trackingHistory => 'Tracking History';

  @override
  String get cycleLengthVarianceWidget_logAtLeastTwoPeriods =>
      'Need at least two cycles to show variance.';

  @override
  String get cycleLengthVarianceWidget_title => 'Cycle Length Variance';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Avg. Cycle';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Cycle';

  @override
  String get periodDurationWidget_logAtLeastTwoPeriods =>
      'Log at least two periods to see period statistics.';

  @override
  String get periodDurationWidget_title => 'Period Duration Variance';

  @override
  String get periodDurationWidget_averagePeriod => 'Avg. Period';

  @override
  String get periodDurationWidget_period => 'Period';

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
  String get sanitaryEntrySheet_logSanitaryProduct => 'Log Sanitary Product';

  @override
  String get sanitaryEntrySheet_setReminderDuration => 'Set Reminder Duration';

  @override
  String sanitaryEntrySheet_maxDuration(int hours) {
    return 'Max Duration: $hours hours';
  }

  @override
  String get sanitaryEntrySheet_futureLogTimeError =>
      'Log time cannot be in the future.';

  @override
  String get sanitaryEntrySheet_pastReminderTimeError =>
      'Reminder end time cannot be in the past.';

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
