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
  String get reset => 'Reset';

  @override
  String get add => 'Add';

  @override
  String get notSet => 'Not set';

  @override
  String get note => 'Note';

  @override
  String get systemDefault => 'Valeur par défaut du système';

  @override
  String get flow => 'Flux /';

  @override
  String get navBar_insights => 'Statistiques';

  @override
  String get navBar_logs => 'Historique';

  @override
  String get navBar_pill => 'Pilule';

  @override
  String get navBar_larc => 'LARC';

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
  String get mainScreen_LarcsPageTitle => 'LARCs';

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
  String get insightsScreen_noDataAvailable => 'Aucune donnée disponible.';

  @override
  String get logsScreen_calculatingPrediction => 'Calcul de la prédication...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Enregistre au moins deux périodes pour estimer le prochain cycle.';

  @override
  String get logScreen_nextPeriodEstimate => 'Prochaine période estimée';

  @override
  String get logScreen_periodDueToday => 'Règles prévues pour aujourd’hui';

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
  String get settingsScreen_enablePillTracking =>
      'Activer le suivi des pilules';

  @override
  String get settingsScreen_pillDescription =>
      'Track your daily pill intake and get reminders.';

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
  String get settingsScreen_pillRegimens => 'Suivis de pilule';

  @override
  String get settingsScreen_makeActive => 'Définir comme actif';

  @override
  String get settingsScreen_activeRegimenReminder =>
      'Paramètres de rappel du régime actif';

  @override
  String get settingsScreen_pack => 'Pack';

  @override
  String get settingsScreen_dataManagement => 'Gestion des données';

  @override
  String get settingsScreen_clearAllLogs => 'Effacer tous les historiques';

  @override
  String get settingsScreen_clearAllPillData =>
      'Effacer toutes les données de la pilule';

  @override
  String get settingsScreen_clearAllPillData_question =>
      'Effacer toutes les données de la pilule ?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'Cela supprimera définitivement votre prise de pilules, vos rappels et votre historique de prise. Cette action est irréversible.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'Toutes les données sur les pilules ont été effacé.';

  @override
  String get settingsScreen_dangerZone => 'Zone Dangereuse';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Supprime l\'intégralité de votre historique de règles et de symptômes.';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Supprime votre régime de pilules et votre historique de prise.';

  @override
  String get settingsScreen_exportPeriodData =>
      'Exporter les donnés de vos périodes';

  @override
  String get settingsScreen_exportPillData => 'Exporter données de vos pilules';

  @override
  String get settingsScreen_exportDataSubtitle =>
      'Créer un fichier de sauvegarde JSON.';

  @override
  String get settingsScreen_exportSuccessful =>
      'Données exportées avec succès.';

  @override
  String get settingsScreen_exportFailed =>
      'L\'exportation a échoué. Veuillez réessayer.';

  @override
  String get settingsScreen_noDataToExport =>
      'Aucune donnée trouvée à exporter.';

  @override
  String get settingsScreen_exportDataMessage =>
      'Voici votre exportation de données MenstruDel.';

  @override
  String get settingsScreen_exportDataTitle => 'Exportation Des Données';

  @override
  String get settingsScreen_importDataTitle => 'Importation Des Données';

  @override
  String get settingsScreen_importPeriodData =>
      'Importer Les Données Des Périodes';

  @override
  String get settingsScreen_importPillData =>
      'Importer Les Données Des Pilules';

  @override
  String get settingsScreen_importDataSubtitle =>
      'Écraser les données existantes.';

  @override
  String get settingsScreen_importPeriodData_question =>
      'Êtes-vous sûr de vouloir importer des données de période ?';

  @override
  String get settingsScreen_importPillData_question =>
      'Êtes-vous sûr de vouloir importer les données de la pilule ?';

  @override
  String get settingsScreen_importPeriodDataDescription =>
      'L\'importation de données écrasera définitivement tout votre historique et paramètres de règles existants. Cette opération est irréversible.';

  @override
  String get settingsScreen_importPillDataDescription =>
      'L\'importation de données écrasera définitivement tout votre historique de pilules. Cette opération est irréversible.';

  @override
  String get settingsScreen_importSuccessful =>
      'Données importées avec succès !';

  @override
  String get settingsScreen_importFailed =>
      'Échec de l\'importation des données. Veuillez réessayer.';

  @override
  String get settingsScreen_importInvalidFile =>
      'Format de fichier ou structure de données non valide.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Échec de l\'importation des données. Veuillez vous assurer que le fichier est enregistré localement.';

  @override
  String settingsScreen_importErrorPlatform(String message) {
    return 'Échec de l\'importation : $message. Veuillez vous assurer que le fichier est enregistré sur l\'appareil et réessayer.';
  }

  @override
  String get settingsScreen_security => 'Sécurité';

  @override
  String get securityScreen_enableBiometricLock =>
      'Activer le verrouillage biométrique';

  @override
  String get securityScreen_enableBiometricLockSubtitle =>
      'Nécessite une empreinte digitale ou un identifiant facial pour ouvrir l\'application.';

  @override
  String get securityScreen_noBiometricsAvailable =>
      'Aucun code d\'accès, empreinte digitale ou Face ID n\'a été trouvé. Veuillez en configurer un dans les paramètres de votre appareil.';

  @override
  String get settingsScreen_preferences => 'Préférences';

  @override
  String get preferencesScreen_language => 'Langue';

  @override
  String get preferencesScreen_tamponReminderButton =>
      'Toujours afficher le bouton de rappel';

  @override
  String get preferencesScreen_tamponReminderButtonSubtitle =>
      'Rend le bouton de rappel du tampon visible en permanence sur l\'écran principal.';

  @override
  String get settingsScreen_about => 'À propos';

  @override
  String get aboutScreen_version => 'Version';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Code source et suivis des erreurs';

  @override
  String get aboutScreen_share => 'Partager';

  @override
  String get aboutScreen_shareSubtitle => 'Partager l\'appli avec vos proches';

  @override
  String get aboutScreen_urlError => 'Impossible d\'ouvrir le lien.';

  @override
  String get tamponReminderDialog_tamponReminderTitle => 'Rappel de tampon';

  @override
  String get tamponReminderDialog_tamponReminderMaxDuration =>
      'La durée maximale est de 8 heures.';

  @override
  String get reminderCountdownDialog_title => 'Rappel à prévoir dans';

  @override
  String reminderCountdownDialog_dueAt(Object time) {
    return 'À prévoir à $time';
  }

  @override
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods =>
      'Il faut au moins deux cycles pour observer une variance.';

  @override
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance =>
      'Variabilité du cycle et des périodes';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Cycle Moyen';

  @override
  String get cycleLengthVarianceWidget_averagePeriod => 'Période Moyenne';

  @override
  String get cycleLengthVarianceWidget_period => 'Période';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Cycle';

  @override
  String get flowIntensityWidget_flowIntensityBreakdown =>
      'Décomposition de l\'intensité du flux';

  @override
  String get flowIntensityWidget_noFlowDataLoggedYet =>
      'Aucune donnée du flux enregistrée pour le moment.';

  @override
  String get painLevelWidget_noPainDataLoggedYet =>
      'Aucune donnée sur la douleur n\'a encore été enregistrée.';

  @override
  String get painLevelWidget_painLevelBreakdown =>
      'Répartition du niveau de douleur';

  @override
  String get monthlyFlowChartWidget_noDataToDisplay =>
      'Aucune donnée à afficher.';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatterns =>
      'Modèles du flux cycliques';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription =>
      'Chaque ligne représente un cycle complet';

  @override
  String get symptomFrequencyWidget_noSymptomsLoggedYet =>
      'Aucun symptôme n\'a encore été enregistré.';

  @override
  String get symptomFrequencyWidget_mostCommonSymptoms =>
      'Symptômes les plus courants';

  @override
  String get yearHeatMapWidget_yearlyOverview => 'Aperçu annuel';

  @override
  String get journalViewWidget_logYourFirstPeriod =>
      'Enregistrer vos premières règles.';

  @override
  String get listViewWidget_noPeriodsLogged =>
      'Aucun cycle menstruel enregistré pour le moment.\nAppuyez sur le bouton + pour en ajouter une.';

  @override
  String get listViewWidget_confirmDelete => 'Confirmer la suppression';

  @override
  String get listViewWidget_confirmDeleteDescription =>
      'Êtes-vous sûr de vouloir supprimer cette entrée ?';

  @override
  String get emptyPillStateWidget_noPillRegimenFound =>
      'Aucun traitement de pilule trouvé.';

  @override
  String get emptyPillStateWidget_noPillRegimenFoundDescription =>
      'Configurez votre plaquette de pilules dans les paramètres pour commencer le suivi.';

  @override
  String pillStatus_pillsOfTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'de $count pilules',
      one: 'd\'une pilule',
    );
    return '$_temp0';
  }

  @override
  String get pillStatus_undo => 'Annuler';

  @override
  String get pillStatus_skip => 'Sauter';

  @override
  String get pillStatus_markAsTaken => 'Marquer Comme Prise';

  @override
  String pillStatus_packStartInFuture(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Votre prochaine plaquette de pilules commence le $dateString.';
  }

  @override
  String get regimenSetupWidget_setUpPillRegimen =>
      'Mettre en place un régime de pilules';

  @override
  String get regimenSetupWidget_packName => 'Nom du paquet de pilules';

  @override
  String get regimenSetupWidget_pleaseEnterAName => 'Veuillez saisir un nom';

  @override
  String get regimenSetupWidget_activePills => 'Pilules actives';

  @override
  String get regimenSetupWidget_enterANumber => 'Entrez un nombre';

  @override
  String get regimenSetupWidget_placeboPills => 'Pilules placebo';

  @override
  String get regimenSetupWidget_firstDayOfThisPack =>
      'Premier jour de cette plaquette';

  @override
  String get symptomEntrySheet_logYourDay => 'Enregistrez votre journée';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Symptômes (Optionnel)';

  @override
  String get periodDetailsSheet_symptoms => 'Symptômes';

  @override
  String get periodDetailsSheet_flow => 'Flux';

  @override
  String periodPredictionCircle_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jours',
      one: 'Jour',
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
