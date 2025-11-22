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
  String get date => 'Data';

  @override
  String get time => 'Ora';

  @override
  String get start => 'Inizio';

  @override
  String get end => 'Fine';

  @override
  String get day => 'Giorno';

  @override
  String get days => 'Giorni';

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
  String get note => 'Note';

  @override
  String get systemDefault => 'System Default';

  @override
  String get flow => 'Flusso';

  @override
  String get navBar_insights => 'Statistiche';

  @override
  String get navBar_logs => 'Calendario';

  @override
  String get navBar_pill => 'Pillola';

  @override
  String get navBar_larc => 'LARC';

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
  String get notification_tamponReminderTitle => 'Promemoria assorbente';

  @override
  String get notification_tamponReminderBody =>
      'Ricordati di cambiare l\'assorbente.';

  @override
  String get notification_larcTitle => 'LARC Reminder';

  @override
  String notification_larcBody(String type, int days) {
    return '$type is due for renewal in $days days.';
  }

  @override
  String get mainScreen_insightsPageTitle => 'Le tue statistiche';

  @override
  String get mainScreen_pillsPageTitle => 'Pillole';

  @override
  String get mainScreen_LarcsPageTitle => 'LARCs';

  @override
  String get mainScreen_settingsPageTitle => 'Impostazioni';

  @override
  String get mainScreen_tooltipSetReminder => 'Promemoria assorbente';

  @override
  String get mainScreen_tooltipCancelReminder => 'Elimina promemoria';

  @override
  String get mainScreen_tooltipLogPeriod => 'Registra ciclo';

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
  String get logScreen_tamponReminderSetFor =>
      'Promemoria assorbente impostato per';

  @override
  String get logScreen_tamponReminderCancelled =>
      'Promemoria assorbente eliminato';

  @override
  String get logScreen_couldNotCancelReminder =>
      'Impossibile cancellare il promemoria';

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pillola di oggi segnata come presa.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pillola di oggi segnata come saltata.';

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
  String get settingsScreen_dangerZone => 'Azioni irreversibili';

  @override
  String get settingsScreen_clearAllLogs => 'Elimina tutti i dati';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Elimina l\'intera cronologia del ciclo e dei sintomi.';

  @override
  String get settingsScreen_clearAllPillData =>
      'Elimina tutti i dati della pillola';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Rimuove il tuo piano pillola e la cronologia delle assunzioni.';

  @override
  String get settingsScreen_clearAllPillData_question =>
      'Eliminare tutti i dati della pillola?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'Questo eliminerà definitivamente il tuo piano pillola, i promemoria e la cronologia delle assunzioni. Questa azione non può essere annullata.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'Tutti i dati della pillola sono stati eliminati.';

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
  String get settingsScreen_exportPeriodData => 'Esporta dati ciclo';

  @override
  String get settingsScreen_exportPillData => 'Esporta dati pillola';

  @override
  String get settingsScreen_exportLarcsData => 'Export LARCs Data';

  @override
  String get settingsScreen_exportDataSubtitle => 'Crea un backup JSON.';

  @override
  String get settingsScreen_exportSuccessful => 'Dati esportati con successo.';

  @override
  String get settingsScreen_exportFailed => 'Esportazione fallita. Riprova.';

  @override
  String get settingsScreen_noDataToExport => 'Nessun dato da esportare.';

  @override
  String get settingsScreen_exportDataMessage =>
      'Ecco la mia esportazione dati di MenstruDel.';

  @override
  String get settingsScreen_exportDataTitle => 'Esporta dati';

  @override
  String get settingsScreen_importDataTitle => 'Importa dati';

  @override
  String get settingsScreen_importPeriodData => 'Importa dati ciclo';

  @override
  String get settingsScreen_importPillData => 'Importa dati pillola';

  @override
  String get settingsScreen_importLarcsData => 'Import LARCs Data';

  @override
  String get settingsScreen_importDataSubtitle =>
      'Sovrascrive i dati esistenti.';

  @override
  String get settingsScreen_importPeriodData_question =>
      'Importare i dati del ciclo?';

  @override
  String get settingsScreen_importPillData_question =>
      'Importare i dati della pillola?';

  @override
  String get settingsScreen_importLarcData_question =>
      'Are you sure you want to import LARC Data?';

  @override
  String get settingsScreen_importPeriodDataDescription =>
      'L\'importazione dei dati sovrascriverà definitivamente tutta la tua cronologia e le impostazioni del ciclo. Questa operazione non può essere annullata.';

  @override
  String get settingsScreen_importPillDataDescription =>
      'L\'importazione dei dati sovrascriverà definitivamente tutta la tua cronologia pillola. Questa operazione non può essere annullata.';

  @override
  String get settingsScreen_importSuccessful => 'Dati importati con successo';

  @override
  String get settingsScreen_importFailed =>
      'Importazione dati fallita. Riprova.';

  @override
  String get settingsScreen_importInvalidFile => 'Formato file non valido.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Importazione dati fallita. Assicurati che il file sia salvato sul dispositivo.';

  @override
  String settingsScreen_importErrorPlatform(String message) {
    return 'Importazione fallita: $message. Assicurati che il file sia salvato sul dispositivo e riprova.';
  }

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
  String get settingsScreen_preferences => 'Preferenze';

  @override
  String get preferencesScreen_language => 'Language';

  @override
  String get preferencesScreen_tamponReminderButton =>
      'Mostra sempre il pulsante promemoria';

  @override
  String get preferencesScreen_tamponReminderButtonSubtitle =>
      'Rende il pulsante promemoria assorbente sempre visibile nella schermata principale.';

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
  String get aboutScreen_share => 'Condividi';

  @override
  String get aboutScreen_shareSubtitle => 'Condividi l\'app con gli amici';

  @override
  String get aboutScreen_urlError => 'Impossibile aprire il link.';

  @override
  String get tamponReminderDialog_tamponReminderTitle =>
      'Promemoria assorbente';

  @override
  String get tamponReminderDialog_tamponReminderMaxDuration =>
      'La durata massima è 8 ore.';

  @override
  String get reminderCountdownDialog_title => 'Promemoria tra';

  @override
  String reminderCountdownDialog_dueAt(Object time) {
    return 'Scade alle $time';
  }

  @override
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods =>
      'Servono almeno due cicli per mostrare le variazioni.';

  @override
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance =>
      'Variazioni ciclo e mestruazioni';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Ciclo medio';

  @override
  String get cycleLengthVarianceWidget_averagePeriod => 'Mestruazioni medie';

  @override
  String get cycleLengthVarianceWidget_period => 'Mestruazioni';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Ciclo mestruale';

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
  String get yearHeatMapWidget_yearlyOverview => 'Riepilogo annuale';

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
  String get larcEntrySheet_logLARCDetails => 'Log LARC Details';

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
