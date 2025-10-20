// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Menstrudel';

  @override
  String get ongoing => 'En cours';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get day => 'Jour';

  @override
  String get days => 'Jours';

  @override
  String dayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Jours',
      one: '$count Jour',
    );
    return '$_temp0';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get clear => 'Effacer';

  @override
  String get save => 'Sauvegarder';

  @override
  String get import => 'Importer';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirmer';

  @override
  String get set => 'Définir';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get cancel => 'Annuler';

  @override
  String get select => 'Sélectionner';

  @override
  String get close => 'Fermer';

  @override
  String get systemDefault => 'System Default';

  @override
  String get flow => 'Flux /';

  @override
  String get navBar_insights => 'Statistiques';

  @override
  String get navBar_logs => 'Historique';

  @override
  String get navBar_pill => 'Pilule';

  @override
  String get navBar_settings => 'Paramètres';

  @override
  String get flowIntensity_none => 'Aucun';

  @override
  String get flowIntensity_spotting => 'Saignement léger';

  @override
  String get flowIntensity_light => 'Léger';

  @override
  String get flowIntensity_moderate => 'Modéré';

  @override
  String get flowIntensity_heavy => 'Abondant';

  @override
  String get defaultSymptom_acne => 'Acne';

  @override
  String get defaultSymptom_backPain => 'Back pain';

  @override
  String get defaultSymptom_bloating => 'Bloating';

  @override
  String get defaultSymptom_cramps => 'Cramps';

  @override
  String get defaultSymptom_fatigue => 'Fatigue';

  @override
  String get defaultSymptom_headache => 'Headache';

  @override
  String get defaultSymptom_moodSwings => 'Mood Swings';

  @override
  String get defaultSymptom_nausea => 'Nausea';

  @override
  String get painLevel_title => 'Intensité de la douleur';

  @override
  String get painLevel_none => 'Aucune';

  @override
  String get painLevel_mild => 'Légère';

  @override
  String get painLevel_moderate => 'Modérée';

  @override
  String get painLevel_severe => 'Forte';

  @override
  String get pain_unbearable => 'Insupportable';

  @override
  String get notification_periodTitle => 'Règles imminentes';

  @override
  String notification_periodBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vos prochaines règles devraient commencer dans $count jours.',
      one: 'Vos prochaines règles devraient commencer dans 1 jour.',
    );
    return '$_temp0';
  }

  @override
  String get notification_periodOverdueTitle => 'Règles en retard';

  @override
  String notification_periodOverdueBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vos prochaines règles sont en retard de $count jours.',
      one: 'Vos prochaines règles sont en retard d\'un jour.',
    );
    return '$_temp0';
  }

  @override
  String get notification_pillTitle => 'Rappel de pilule';

  @override
  String get notification_pillBody =>
      'N’oubliez pas de prendre votre pilule aujourd’hui.';

  @override
  String get notification_tamponReminderTitle => 'Rappel de tampon';

  @override
  String get notification_tamponReminderBody =>
      'N\'oubliez pas de changer votre tampon.';

  @override
  String get mainScreen_insightsPageTitle => 'Votre Aperçu';

  @override
  String get mainScreen_pillsPageTitle => 'Pilules';

  @override
  String get mainScreen_settingsPageTitle => 'Paramètres';

  @override
  String get mainScreen_tooltipSetReminder => 'Rappel de tampon';

  @override
  String get mainScreen_tooltipCancelReminder => 'Annuler le rappel';

  @override
  String get mainScreen_tooltipLogPeriod => 'Historique des règles';

  @override
  String get insightsScreen_errorPrefix => 'Erreur :';

  @override
  String get insightsScreen_noDataAvailable => 'Aucune donnée disponible. ';

  @override
  String get logsScreen_calculatingPrediction => 'Calcul de la prédication...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Enregistre au moins deux périodes pour estimer le prochain cycle.';

  @override
  String get logScreen_nextPeriodEstimate => 'Prochaine période estimée';

  @override
  String get logScreen_periodDueToday => 'Règles prévues pour aujourd’hui.';

  @override
  String logScreen_periodOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Règles en retard de $count jours',
      one: 'Règles en retard d’un jour',
    );
    return '$_temp0';
  }

  @override
  String get logScreen_tamponReminderSetFor => 'Rappel de tampon réglé pour';

  @override
  String get logScreen_tamponReminderCancelled => 'Rappel de tampon annulé.';

  @override
  String get logScreen_couldNotCancelReminder =>
      'Impossible d’annuler le rappel';

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pilule du jour marquée comme prise.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pilule du jour marquée comme sautée.';

  @override
  String get settingsScreen_selectHistoryView =>
      'Sélectionner la vue de l\'historique';

  @override
  String get settingsScreen_deleteRegimen_question =>
      'Supprimer le traitement ?';

  @override
  String get settingsScreen_deleteRegimenDescription =>
      'Cela supprimera les réglages de votre plaquette actuelle ainsi que tous les journaux de pilules associés. Cette action est irréversible.';

  @override
  String get settingsScreen_allLogsHaveBeenCleared =>
      'Tout l’historique a été supprimé.';

  @override
  String get settingsScreen_clearAllLogs_question =>
      'Supprimer tout l’historique ?';

  @override
  String get settingsScreen_deleteAllLogsDescription =>
      'Tous vos suivis de règles seront définitivement supprimés, mais vos paramètres resteront inchangés.';

  @override
  String get settingsScreen_appearance => 'Apparence';

  @override
  String get settingsScreen_historyViewStyle =>
      'Style d’affichage de l’historique';

  @override
  String get settingsScreen_appTheme => 'Thème de l’application';

  @override
  String get settingsScreen_themeLight => 'Clair';

  @override
  String get settingsScreen_themeDark => 'Sombre';

  @override
  String get settingsScreen_themeSystem => 'Système';

  @override
  String get settingsScreen_dynamicTheme => 'Thème dynamique';

  @override
  String get settingsScreen_useWallpaperColors =>
      'Utiliser les couleurs du fond d’écran';

  @override
  String get settingsScreen_themeColor => 'Couleur du thème';

  @override
  String get settingsScreen_pickAColor => 'Sélectionner une couleur';

  @override
  String get settingsScreen_view => 'Vue';

  @override
  String get settingsScreen_birthControl => 'Contraception';

  @override
  String get settingsScreen_setUpPillRegimen =>
      'Configurer le régime de pilule';

  @override
  String get settingsScreen_trackYourDailyPillIntake =>
      'Suivi quotidien de la pilule';

  @override
  String get settingsScreen_dailyPillReminder =>
      'Rappel pour la pilule quotidienne';

  @override
  String get settingsScreen_reminderTime => 'Heure du rappel';

  @override
  String get settingsScreen_periodPredictionAndReminders =>
      'Prédiction des règles et rappels';

  @override
  String get settingsScreen_upcomingPeriodReminder =>
      'Rappel des prochaines règles';

  @override
  String get settingsScreen_remindMeBefore => 'M’avertir avant';

  @override
  String get settingsScreen_notificationTime => 'Heure de la notification';

  @override
  String get settingsScreen_overduePeriodReminder =>
      'Alerte de retard de règles';

  @override
  String get settingsScreen_remindMeAfter => 'Me rappeler après';

  @override
  String get settingsScreen_pillRegimens => 'Suivis de pilule';

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
}
