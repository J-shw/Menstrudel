// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Menstrudel';

  @override
  String get nextDue => 'Next Due';

  @override
  String get ongoing => 'In corso';

  @override
  String get overdue => 'Overdue';

  @override
  String get total => 'Total';

  @override
  String get shortest => 'Shortest';

  @override
  String get longest => 'Longest';

  @override
  String get date => 'Data';

  @override
  String get time => 'Ora';

  @override
  String get start => 'Inizio';

  @override
  String get end => 'Fine';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get today => 'Today';

  @override
  String get day => 'Giorno';

  @override
  String get days => 'Giorni';

  @override
  String get hours => 'Hours';

  @override
  String dayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Giorni',
      one: '$count Giorno',
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
  String countdown_daysLeft(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Days left',
      one: '$days Day left',
    );
    return '$_temp0';
  }

  @override
  String get logs => 'Logs';

  @override
  String get insights => 'Insights';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Elimina';

  @override
  String get clear => 'Cancella';

  @override
  String get save => 'Salva';

  @override
  String get import => 'Importa';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Conferma';

  @override
  String get set => 'Imposta';

  @override
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get cancel => 'Annulla';

  @override
  String get select => 'Seleziona';

  @override
  String get close => 'Chiudi';

  @override
  String get reset => 'Reset';

  @override
  String get add => 'Add';

  @override
  String get notSet => 'Not set';

  @override
  String get removed => 'Removed';

  @override
  String get totalLogs => 'Total Logs';

  @override
  String get note => 'Note';

  @override
  String get systemDefault => 'System Default';

  @override
  String get flow => 'Flusso';

  @override
  String get type => 'Type';

  @override
  String get other => 'Other';

  @override
  String get navBar_logs => 'Calendario';

  @override
  String get navBar_sanitary => 'Sanitary';

  @override
  String get navBar_sexActivity => 'Sex Activity';

  @override
  String get navBar_pill => 'Pillola';

  @override
  String get navBar_reversibleContraceptive => 'Contraceptives';

  @override
  String get navBar_settings => 'Impostazioni';

  @override
  String get flowIntensity_none => 'Assente';

  @override
  String get flowIntensity_spotting => 'Spotting';

  @override
  String get flowIntensity_light => 'Leggero';

  @override
  String get flowIntensity_moderate => 'Medio';

  @override
  String get flowIntensity_heavy => 'Abbondante';

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
  String get painLevel_title => 'Intensità del dolore';

  @override
  String get painLevel_none => 'Assente';

  @override
  String get painLevel_mild => 'Leggero';

  @override
  String get painLevel_moderate => 'Medio';

  @override
  String get painLevel_severe => 'Forte';

  @override
  String get pain_unbearable => 'Insopportabile';

  @override
  String get reversibleContraceptive_hormonalIud => 'Hormonal IUD';

  @override
  String get reversibleContraceptive_copperIud => 'Copper IUD';

  @override
  String get reversibleContraceptive_implant => 'Implant';

  @override
  String get reversibleContraceptive_injection => 'Injection';

  @override
  String get reversibleContraceptive_ring => 'Ring';

  @override
  String get reversibleContraceptive_patch => 'Patch';

  @override
  String get sanitaryProduct_tampon => 'Tampon';

  @override
  String get sanitaryProduct_pad => 'Pad';

  @override
  String get sanitaryProduct_menstrualCup => 'Menstrual Cup';

  @override
  String get sanitaryProduct_periodUnderwear => 'Period Underwear';

  @override
  String get sanitaryProducts_mostUsed => 'Most Used';

  @override
  String get sanitaryProducts_usageTrend => 'Usage Trend';

  @override
  String get sexProtection_none => 'None';

  @override
  String get sexProtection_barrier => 'Barrier';

  @override
  String get sexProtection_hormonal => 'Hormonal';

  @override
  String get sexProtection_natural => 'Natural';

  @override
  String get sexProtection_permanent => 'Permanent';

  @override
  String get sexType_vaginal => 'Vaginal';

  @override
  String get sexType_anal => 'Anal';

  @override
  String get sexType_oral => 'Oral';

  @override
  String get sexType_manual => 'Manual';

  @override
  String get sexParticipation_solo => 'Solo';

  @override
  String get sexParticipation_partner => 'Partner';

  @override
  String get sexParticipation_group => 'Group';

  @override
  String get userGoal_general => 'General Health';

  @override
  String get userGoal_sexual => 'Sexual Health';

  @override
  String get userGoal_conceive => 'Trying to Conceive';

  @override
  String get userGoal_avoid => 'Avoiding Pregnancy';

  @override
  String get dayOfWeek_monday => 'Monday';

  @override
  String get dayOfWeek_tuesday => 'Tuesday';

  @override
  String get dayOfWeek_wednesday => 'Wednesday';

  @override
  String get dayOfWeek_thursday => 'Thursday';

  @override
  String get dayOfWeek_friday => 'Friday';

  @override
  String get dayOfWeek_saturday => 'Saturday';

  @override
  String get dayOfWeek_sunday => 'Sunday';

  @override
  String get cyclePhase_menstruation => 'On Period';

  @override
  String get cyclePhase_follicular => 'Pre-Ovulation';

  @override
  String get cyclePhase_ovulation => 'Peak Fertility';

  @override
  String get cyclePhase_luteal => 'Post-Ovulation';

  @override
  String get cyclePhase_late => 'Late';

  @override
  String get cyclePhase_unknown => 'Unknown';

  @override
  String get cyclePhase_menstruationDescription =>
      'Your period is active and the uterine lining is being shed.';

  @override
  String get cyclePhase_follicularDescription =>
      'Estrogen is rising to prepare the egg; your energy levels may be increasing.';

  @override
  String get cyclePhase_ovulationDescription =>
      'An egg has been released. This is your most fertile time.';

  @override
  String get cyclePhase_lutealDescription =>
      'Progesterone is dominant. Monitor for PMS symptoms as you approach your next period.';

  @override
  String get cyclePhase_lateDescription => 'Your period is late.';

  @override
  String get cyclePhase_unknownDescription =>
      'We need more data to accurately predict your cycle phase.';

  @override
  String get error_valueMustbePositive => 'Value must be positive';

  @override
  String get error_valueCannotBeNull => 'Value cannot be null';

  @override
  String get notification_periodTitle => 'Ciclo in arrivo';

  @override
  String notification_periodBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il tuo prossimo ciclo dovrebbe iniziare tra $count giorni.',
      one: 'Il tuo prossimo ciclo dovrebbe iniziare tra 1 giorno.',
    );
    return '$_temp0';
  }

  @override
  String get notification_periodOverdueTitle => 'Ciclo in ritardo';

  @override
  String notification_periodOverdueBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il tuo ciclo è in ritardo di $count giorni.',
      one: 'Il tuo ciclo è in ritardo di 1 giorno.',
    );
    return '$_temp0';
  }

  @override
  String get notification_pillTitle => 'Promemoria pillola';

  @override
  String get notification_pillBody =>
      'Non dimenticare di prendere la pillola oggi.';

  @override
  String get notification_reversibleContraceptiveTitle =>
      'Reversible Contraceptive Reminder';

  @override
  String notification_reversibleContraceptiveBody(String type, int days) {
    return '$type is due for renewal in $days days.';
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
  String get onboardingScreen_welcomeToMenstrudel => 'Welcome to Menstrudel';

  @override
  String get onboardingScreen_welcomeToMenstrudelDescription =>
      'Your offline, private cycle tracker.';

  @override
  String get onboardingScreen_profileTitle => 'About You';

  @override
  String get onboardingScreen_profileName => 'What should we call you?';

  @override
  String get onboardingScreen_profileDate => 'Birth Date (Optional)';

  @override
  String get onboardingScreen_profileDatePlaceholder => 'Tap to set birthday';

  @override
  String get onboardingScreen_goalTitle => 'What\'s your goal?';

  @override
  String get onboardingScreen_goalDescription =>
      'This helps tailor the insights you see.';

  @override
  String onboardingScreen_contraceptionHint(String sectionName) {
    return 'Note: You can enable Pill or LARC tracking later in the app settings under \'$sectionName\' if wanted.';
  }

  @override
  String get onboardingScreen_getStarted => 'Get Started';

  @override
  String get fabToolTip_logs => 'Log day';

  @override
  String get fabToolTip_sanitary => 'Log sanitary product';

  @override
  String get fabToolTip_sexActivity => 'Log sex activity';

  @override
  String get fabToolTip_reversibleContraceptive =>
      'Log Reversible Contraceptive';

  @override
  String get mainScreen_logsPageTitle => 'Logs';

  @override
  String get mainSceen_sexActivityPageTitle => 'Sex Activity';

  @override
  String get mainScreen_sanitaryPageTitle => 'Sanitary Products';

  @override
  String get mainScreen_pillsPageTitle => 'Pillole';

  @override
  String get mainScreen_reversibleContraceptivesPageTitle =>
      'Reversible Contraceptives';

  @override
  String get mainScreen_settingsPageTitle => 'Impostazioni';

  @override
  String get insightsScreen_errorPrefix => 'Errore:';

  @override
  String get insightsScreen_noDataAvailable => 'Nessun dato disponibile.';

  @override
  String get logsScreen_calculatingPrediction =>
      'Calcolo previsione in corso...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Registra almeno due cicli per stimare il prossimo.';

  @override
  String get logScreen_nextPeriodEstimate => 'Prossimo ciclo previsto';

  @override
  String get logScreen_periodDueToday => 'Ciclo previsto per oggi';

  @override
  String logScreen_periodOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ciclo in ritardo di $count giorni',
      one: 'Ciclo in ritardo di 1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pillola di oggi segnata come presa.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pillola di oggi segnata come saltata.';

  @override
  String get reversibleContraceptiveScreen_noRecordsFound =>
      'No records found.';

  @override
  String reversibleContraceptiveScreen_history(int history) {
    return 'History ($history)';
  }

  @override
  String reversibleContraceptiveScreen_activeReversibleContraceptives(
    int activeCount,
  ) {
    return 'Active ($activeCount)';
  }

  @override
  String
  get reversibleContraceptiveScreen_activeReversibleContraceptivesDescription =>
      'Currently monitored reversible contraceptive entries.';

  @override
  String get reversibleContraceptiveScreen_noActiveRecords =>
      'No reversible contraceptive is currently active. Please log a new entry.';

  @override
  String get reversibleContraceptiveScreen_noHistoryRecords =>
      'No past or overdue reversible contraceptive records found.';

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
  String get sexActivityScreen_noSexActivityRecordsFound =>
      'No sex activity records found.';

  @override
  String sexActivityScreen_history(int history) {
    return 'History ($history)';
  }

  @override
  String get sexActivityScreen_primaryMethod => 'Primary Method';

  @override
  String get sexActivityScreen_mostFrequent => 'Most Frequent';

  @override
  String get sexActivityScreen_protected => 'Protected';

  @override
  String get sexActivityScreen_activityDistribution => 'Activity Distribution';

  @override
  String get settingsScreen_profile => 'Profile';

  @override
  String get settingsScreen_name => 'Name';

  @override
  String get settingsScreen_birthDate => 'Birth Date';

  @override
  String get settingsScreen_notSet => 'Not set';

  @override
  String get settingsScreen_appGoal => 'App Goal';

  @override
  String get settingsScreen_profileUpdated => 'Profile updated successfully';

  @override
  String get settingsScreen_selectHistoryView => 'Seleziona vista cronologia';

  @override
  String get settingsScreen_deleteRegimen_question =>
      'Cancellare piano pillola?';

  @override
  String get settingsScreen_deleteRegimenDescription =>
      'Questo eliminerà le impostazioni della tua confezione di pillole e tutta la cronologia associata. Questa operazione non può essere annullata.';

  @override
  String get settingsScreen_allLogsHaveBeenCleared =>
      'Tutti i dati sono stati eliminati.';

  @override
  String get settingsScreen_clearAllLogs_question => 'Eliminare tutti i dati?';

  @override
  String get settingsScreen_deleteAllLogsDescription =>
      'Questo cancellerà definitivamente tutti i dati del ciclo. Le impostazioni dell\'app non verranno modificate.';

  @override
  String get settingsScreen_appearance => 'Aspetto';

  @override
  String get settingsScreen_historyViewStyle => 'Aspetto della cronologia';

  @override
  String get settingsScreen_appTheme => 'Tema app';

  @override
  String get settingsScreen_themeLight => 'Chiaro';

  @override
  String get settingsScreen_themeDark => 'Scuro';

  @override
  String get settingsScreen_themeSystem => 'Come il sistema';

  @override
  String get settingsScreen_dynamicTheme => 'Tema dinamico';

  @override
  String get settingsScreen_useWallpaperColors => 'Usa i colori dello sfondo';

  @override
  String get settingsScreen_themeColor => 'Colore tema';

  @override
  String get settingsScreen_pickAColor => 'Scegli un colore';

  @override
  String get settingsScreen_view => 'Visualizza';

  @override
  String get settingsScreen_birthControl => 'Contraccezione';

  @override
  String get settingsScreen_enablePillTracking => 'Enable Pill Tracking';

  @override
  String get settingsScreen_pillDescription =>
      'Track your daily pill intake and get reminders.';

  @override
  String get settingsScreen_setUpPillRegimen => 'Crea piano pillola';

  @override
  String get settingsScreen_trackYourDailyPillIntake =>
      'Monitoraggio pillola giornaliero';

  @override
  String get settingsScreen_dailyPillReminder =>
      'Promemoria pillola giornaliero';

  @override
  String get settingsScreen_reminderTime => 'Orario promemoria';

  @override
  String get settingsScreen_periodPredictionAndReminders =>
      'Previsioni ciclo e promemoria';

  @override
  String get settingsScreen_upcomingPeriodReminder =>
      'Promemoria ciclo in arrivo';

  @override
  String get settingsScreen_remindMeBefore => 'Avvisami prima';

  @override
  String get settingsScreen_notificationTime => 'Orario notifica';

  @override
  String get settingsScreen_overduePeriodReminder =>
      'Promemoria ciclo in ritardo';

  @override
  String get settingsScreen_remindMeAfter => 'Avvisami dopo';

  @override
  String get settingsScreen_enableReversibleContraceptiveTracking =>
      'Enable Reversible Contraceptive Tracking';

  @override
  String get settingsScreen_reversibleContraceptiveDescription =>
      'Track Reversible Contraceptives.';

  @override
  String get settingsScreen_reversibleContraceptiveType => 'Contraceptive Type';

  @override
  String get settingsScreen_setDuration => 'Set Duration';

  @override
  String get settingsScreen_reversibleContraceptiveDuration =>
      'Contraceptive Replacement Duration';

  @override
  String get settingsScreen_enableReversibleContraceptiveReminder =>
      'Enable Contraceptive Reminder';

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
  String get settingsScreen_pillRegimens => 'Piani pillola';

  @override
  String get settingsScreen_makeActive => 'Imposta come attivo';

  @override
  String get settingsScreen_activeRegimenReminder =>
      'Impostazioni promemoria piano attivo';

  @override
  String get settingsScreen_pack => 'Confezione';

  @override
  String get settingsScreen_dataManagement => 'Gestione dati';

  @override
  String get settingsScreen_deleteZone => 'Delete Zone';

  @override
  String get settingsScreen_clearLogsAndPeriods => 'Clear Logs & Periods';

  @override
  String get settingsScreen_clearLogsAndPeriodsSubtitle =>
      'Deletes your entire period and symptom history.';

  @override
  String get settingsScreen_clearPillLogs => 'Clear Pill Logs';

  @override
  String get settingsScreen_clearPillLogsSubtitle =>
      'Removes your pill regimen and intake history.';

  @override
  String get settingsScreen_clearReversibleContraceptiveLogs =>
      'Clear Reversible Contraceptive Logs';

  @override
  String get settingsScreen_clearReversibleContraceptiveLogsSubtitle =>
      'Removes your reversible contraceptive history.';

  @override
  String get settingsScreen_clearSanitaryProductLogs =>
      'Clear Sanitary Product Logs';

  @override
  String get settingsScreen_clearSanitaryProductLogsSubtitle =>
      'Removes your sanitary products history.';

  @override
  String get settingsScreen_clearSexualActivityLogs =>
      'Clear Sexual Activity Logs';

  @override
  String get settingsScreen_clearSexualActivityLogsSubtitle =>
      'Removes your sexual activity history.';

  @override
  String get settingsScreen_logsAndPeriods => 'Logs & Periods';

  @override
  String get settingsScreen_pillLogs => 'Pill Logs';

  @override
  String get settingsScreen_reversibleContraceptivesLogs =>
      'Reversible Contraceptive Logs';

  @override
  String get settingsScreen_sanitaryProductLogs => 'Sanitary Product Logs';

  @override
  String get settingsScreen_sexualActivityLogs => 'Sexual Activity Logs';

  @override
  String get settingsScreen_importSupportNote =>
      'Import is currently only supported for files exported from Menstrudel.';

  @override
  String get settingsScreen_exportSuccessful => 'Dati esportati con successo.';

  @override
  String get settingsScreen_exportFailed => 'Esportazione fallita. Riprova.';

  @override
  String get settingsScreen_exportDataTitle => 'Esporta dati';

  @override
  String get settingsScreen_importDataTitle => 'Importa dati';

  @override
  String get settingsScreen_importDataSubtitle =>
      'Sovrascrive i dati esistenti.';

  @override
  String get settingsScreen_importSuccessful => 'Dati importati con successo';

  @override
  String get settingsScreen_importFailed =>
      'Importazione dati fallita. Riprova.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Importazione dati fallita. Assicurati che il file sia salvato sul dispositivo.';

  @override
  String get settingsScreen_security => 'Sicurezza';

  @override
  String get securityScreen_enableBiometricLock => 'Abilita blocco biometrico';

  @override
  String get securityScreen_enableBiometricLockSubtitle =>
      'Richiedi impronta digitale o riconoscimento facciale per aprire l\'app.';

  @override
  String get securityScreen_noBiometricsAvailable =>
      'Nessun codice di sblocco, impronta digitale o riconoscimento facciale trovato. Configuralo nelle impostazioni del tuo dispositivo.';

  @override
  String get settingsScreen_userProfile => 'You';

  @override
  String get settingsScreen_preferences => 'Preferenze';

  @override
  String get preferencesScreen_language => 'Language';

  @override
  String get preferencesScreen_enableSanitaryProductsScreen =>
      'Enable Sanitary Products Screen';

  @override
  String get preferencesScreen_enableSanitaryProductsScreenSubtitle =>
      'Show the Sanitary Products tab on the main navigation bar.';

  @override
  String get preferencesScreen_enableSexActivityScreen =>
      'Enable Sex Activity Screen';

  @override
  String get preferencesScreen_enableSexActivityScreenSubtitle =>
      'Show the Sex Activity tab on the main navigation bar.';

  @override
  String get preferencesScreen_StartingDayOfWeek => 'Starting Day of the Week';

  @override
  String get settingsScreen_about => 'Informazioni';

  @override
  String get aboutScreen_version => 'Versione';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle =>
      'Codice sorgente e segnalazione errori';

  @override
  String get aboutScreen_discord => 'Discord';

  @override
  String get aboutScreen_discordSubtitle => 'Support and community';

  @override
  String get aboutScreen_share => 'Condividi';

  @override
  String get aboutScreen_shareSubtitle => 'Condividi l\'app con gli amici';

  @override
  String get aboutScreen_urlError => 'Impossibile aprire il link.';

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
  String get cycleLengthVarianceWidget_averageCycle => 'Ciclo medio';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Ciclo mestruale';

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
      'Dettaglio intensità flusso';

  @override
  String get flowIntensityWidget_noFlowDataLoggedYet =>
      'Nessun dato del flusso registrato.';

  @override
  String get painLevelWidget_noPainDataLoggedYet =>
      'Nessun dato dolore registrato.';

  @override
  String get painLevelWidget_painLevelBreakdown => 'Dettagli livello dolore';

  @override
  String get monthlyFlowChartWidget_noDataToDisplay =>
      'Nessun dato da mostrare.';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatterns =>
      'Andamenti del flusso mestruale';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription =>
      'Ogni linea rappresenta un ciclo completo.';

  @override
  String get symptomFrequencyWidget_noSymptomsLoggedYet =>
      'Nessun sintomo registrato.';

  @override
  String get symptomFrequencyWidget_mostCommonSymptoms => 'Sintomi più comuni';

  @override
  String get journalViewWidget_logYourFirstPeriod =>
      'Registra il tuo primo ciclo.';

  @override
  String get listViewWidget_noPeriodsLogged =>
      'Nessun ciclo registrato.\nTocca il pulsante + per aggiungerne uno.';

  @override
  String get listViewWidget_confirmDelete => 'Conferma eliminazione';

  @override
  String get listViewWidget_confirmDeleteDescription =>
      'Sei sicura di voler eliminare questa voce?';

  @override
  String get emptyPillStateWidget_noPillRegimenFound =>
      'Nessun piano pillola trovato.';

  @override
  String get emptyPillStateWidget_noPillRegimenFoundDescription =>
      'Configura la tua confezione di pillole nelle impostazioni per iniziare il monitoraggio.';

  @override
  String pillStatus_pillsOfTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'di $count pillole',
      one: 'di 1 pillola',
    );
    return '$_temp0';
  }

  @override
  String get pillStatus_undo => 'Annulla';

  @override
  String get pillStatus_skip => 'Salta';

  @override
  String get pillStatus_markAsTaken => 'Segna come presa';

  @override
  String pillStatus_packStartInFuture(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'La tua prossima confezione di pillole inizia il $dateString.';
  }

  @override
  String get regimenSetupWidget_setUpPillRegimen => 'Configura piano pillola';

  @override
  String get regimenSetupWidget_packName => 'Nome confezione';

  @override
  String get regimenSetupWidget_pleaseEnterAName => 'Inserire un nome';

  @override
  String get regimenSetupWidget_activePills => 'Pillole attive';

  @override
  String get regimenSetupWidget_enterANumber => 'Inserire un numero';

  @override
  String get regimenSetupWidget_placeboPills => 'Pillole vuote (placebo)';

  @override
  String get regimenSetupWidget_firstDayOfThisPack =>
      'Primo giorno di questa confezione';

  @override
  String get symptomEntrySheet_logYourDay => 'Inserisci i dati giornalieri';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Sintomi (facoltativo)';

  @override
  String get periodDetailsSheet_symptoms => 'Sintomi';

  @override
  String get periodDetailsSheet_flow => 'Flusso';

  @override
  String
  get reversibleContraceptiveEntrySheet_logReversibleContraceptiveDetails =>
      'Log Contraceptive Details';

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
      other: 'Giorni',
      one: 'Giorno',
    );
    return '$_temp0';
  }

  @override
  String get customSymptomDialog_newSymptom => 'New Symptom';

  @override
  String get customSymptomDialog_enterCustomSymptom =>
      'Please enter a custom symptom';

  @override
  String get customSymptomDialog_temporarySymptom => 'Temporary Symptom';
}
