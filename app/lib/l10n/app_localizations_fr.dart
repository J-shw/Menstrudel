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
  String get nextDue => 'Prochaine échéance';

  @override
  String get ongoing => 'En cours';

  @override
  String get overdue => 'Retard';

  @override
  String get total => 'Total';

  @override
  String get shortest => 'Shortest';

  @override
  String get longest => 'Longest';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get today => 'Today';

  @override
  String get day => 'Jour';

  @override
  String get days => 'Jours';

  @override
  String get hours => 'Heures';

  @override
  String dayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String monthCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mois',
      one: '$count mois',
    );
    return '$_temp0';
  }

  @override
  String yearCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count années',
      one: '$count année',
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
  String get edit => 'Éditer';

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
  String get reset => 'Réinitialiser';

  @override
  String get add => 'Ajouter';

  @override
  String get notSet => 'Non-défini';

  @override
  String get removed => 'Supprimé';

  @override
  String get totalLogs => 'Total Logs';

  @override
  String get note => 'Note';

  @override
  String get systemDefault => 'Valeur par défaut du système';

  @override
  String get flow => 'Flux /';

  @override
  String get type => 'Écrire';

  @override
  String get other => 'Other';

  @override
  String get navBar_logs => 'Suivis';

  @override
  String get navBar_sanitary => 'Sanitaire';

  @override
  String get navBar_sexActivity => 'Sex Activity';

  @override
  String get navBar_pill => 'Pilule';

  @override
  String get navBar_reversibleContraceptive => 'Contraceptives';

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
  String get builtInSymptom_acne => 'Acné';

  @override
  String get builtInSymptom_backPain => 'Mal de dos';

  @override
  String get builtInSymptom_bloating => 'Ballonnements';

  @override
  String get builtInSymptom_cramps => 'Crampes';

  @override
  String get builtInSymptom_fatigue => 'Fatigue';

  @override
  String get builtInSymptom_headache => 'Migraine';

  @override
  String get builtInSymptom_moodSwings => 'Sauts d\'humeur';

  @override
  String get builtInSymptom_nausea => 'Nausée';

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
  String get sanitaryProduct_pad => 'Serviette hygiénique';

  @override
  String get sanitaryProduct_menstrualCup => 'Coupe menstruelle';

  @override
  String get sanitaryProduct_periodUnderwear => 'Lingerie menstruelle';

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
  String get error_valueMustbePositive =>
      'La valeur doit être supérieure à zéro';

  @override
  String get error_valueCannotBeNull => 'La valeur ne peut pas être vide';

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
  String get notification_reversibleContraceptiveTitle =>
      'Reversible Contraceptive Reminder';

  @override
  String notification_reversibleContraceptiveBody(String type, int days) {
    return '$type is due for renewal in $days days.';
  }

  @override
  String get notification_loggingReminderTitle => 'Rappel de suivi';

  @override
  String get notification_loggingReminderBody =>
      'Appuyer pour enregistrer votre flux d\'aujourd\'hui.';

  @override
  String get notification_SanitaryProductReminderTitle =>
      'Rappel des produits hygiénique';

  @override
  String get notification_SanitaryProductReminderBody =>
      'N\'oubliez pas de changer votre produit hygiénique.';

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
  String get mainScreen_sanitaryPageTitle => 'Produits hygiéniques';

  @override
  String get mainScreen_pillsPageTitle => 'Pilules';

  @override
  String get mainScreen_reversibleContraceptivesPageTitle =>
      'Reversible Contraceptives';

  @override
  String get mainScreen_settingsPageTitle => 'Paramètres';

  @override
  String get insightsScreen_errorPrefix => 'Erreur:';

  @override
  String get insightsScreen_noDataAvailable => 'Aucune donnée disponible.';

  @override
  String get logsScreen_calculatingPrediction => 'Calcul de la prédication...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Enregistrer au moins deux périodes pour estimer le prochain cycle.';

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
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pilule du jour marquée comme prise.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pilule du jour marquée comme sautée.';

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
      'Aucun enregistrement de produit hygiénique n\'a été trouvé.';

  @override
  String sanitaryProductsScreen_history(int history) {
    return 'Historique ($history)';
  }

  @override
  String get sanitaryProductsScreen_noHistoryRecords =>
      'Aucun enregistrement de produit hygiénique n\'a été trouvé.';

  @override
  String sanitaryProductsScreen_activeProduct(String activeType) {
    return 'Actif$activeType';
  }

  @override
  String sanitaryProductsScreen_changeDueAt(String time) {
    return 'Changement prévu à $time';
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
      'Suivez votre prise quotidienne de pilule et recevez des rappels.';

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
  String get settingsScreen_enableReversibleContraceptiveTracking =>
      'Enable Reversible Contraceptive Tracking';

  @override
  String get settingsScreen_reversibleContraceptiveDescription =>
      'Track Reversible Contraceptives.';

  @override
  String get settingsScreen_reversibleContraceptiveType => 'Contraceptive Type';

  @override
  String get settingsScreen_setDuration => 'Déterminer une durée';

  @override
  String get settingsScreen_reversibleContraceptiveDuration =>
      'Contraceptive Replacement Duration';

  @override
  String get settingsScreen_enableReversibleContraceptiveReminder =>
      'Enable Contraceptive Reminder';

  @override
  String get settingsScreen_currentDuration => 'Durée actuelle';

  @override
  String get settingsScreen_durationInDays => 'Durée (Jours)';

  @override
  String get settingsScreen_LoggingScreen => 'Suivi';

  @override
  String get settingsScreen_enableLoggingReminders =>
      'Activer un rappel de suivis';

  @override
  String get settingsScreen_loggingReminderDescription =>
      'Si vous enregistrez un jour avec flux, vous recevrez une notification le lendemain pour enregistrer votre statut.';

  @override
  String get settingsScreen_loggingReminderTime => 'Heure du rappel de suivi';

  @override
  String get settingsScreen_defaultSymptoms => 'Symptômes par défaut';

  @override
  String get settingsScreen_defaultSymptomsSubtitle =>
      'Ceux-ci sont toujours disponibles lorsque vous enregistrez de nouveaux cycles de règles.\nAppuyez sur un symptôme existant pour le supprimer ou sur « + » pour en ajouter un nouveau.';

  @override
  String settingsScreen_deleteDefaultSymptomQuestion(String symptom) {
    return 'Supprimer \'$symptom\'?';
  }

  @override
  String get settingsScreen_resetSymptomsList =>
      'Réinitialiser la liste des symptômes ?';

  @override
  String get settingsScreen_resetSymptomsListDescription =>
      'Cela supprimera tous vos symptômes personnalisés et restaurera la liste d\'origine.\n\nVos entrées existantes ne seront pas modifiées.';

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
  String get settingsScreen_exportSuccessful =>
      'Données exportées avec succès.';

  @override
  String get settingsScreen_exportFailed =>
      'L\'exportation a échoué. Veuillez réessayer.';

  @override
  String get settingsScreen_exportDataTitle => 'Exportation Des Données';

  @override
  String get settingsScreen_importDataTitle => 'Importation Des Données';

  @override
  String get settingsScreen_importDataSubtitle =>
      'Écraser les données existantes.';

  @override
  String get settingsScreen_importSuccessful =>
      'Données importées avec succès !';

  @override
  String get settingsScreen_importFailed =>
      'Échec de l\'importation des données. Veuillez réessayer.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Échec de l\'importation des données. Veuillez vous assurer que le fichier est enregistré localement.';

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
  String get settingsScreen_userProfile => 'You';

  @override
  String get settingsScreen_preferences => 'Préférences';

  @override
  String get preferencesScreen_language => 'Langue';

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
  String get settingsScreen_about => 'À propos';

  @override
  String get aboutScreen_version => 'Version';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Code source et suivis des erreurs';

  @override
  String get aboutScreen_discord => 'Discord';

  @override
  String get aboutScreen_discordSubtitle => 'Support et communauté';

  @override
  String get aboutScreen_share => 'Partager';

  @override
  String get aboutScreen_shareSubtitle => 'Partager l\'appli avec vos proches';

  @override
  String get aboutScreen_urlError => 'Impossible d\'ouvrir le lien.';

  @override
  String get logSummaryWidget_loggedDays => 'Jours suivis';

  @override
  String get logSummaryWidget_trackingHistory => 'Historique de suivi';

  @override
  String get cycleLengthVarianceWidget_logAtLeastTwoPeriods =>
      'Need at least two cycles to show variance.';

  @override
  String get cycleLengthVarianceWidget_title => 'Cycle Length Variance';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Cycle Moyen';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Cycle';

  @override
  String get periodDurationWidget_logAtLeastTwoPeriods =>
      'Enregistrez au moins deux cycles pour voir les statistiques de règles.';

  @override
  String get periodDurationWidget_title => 'Period Duration Variance';

  @override
  String get periodDurationWidget_averagePeriod => 'Moyenne de règles';

  @override
  String get periodDurationWidget_period => 'Règles';

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
  String
  get reversibleContraceptiveEntrySheet_logReversibleContraceptiveDetails =>
      'Log Contraceptive Details';

  @override
  String get sanitaryEntrySheet_logSanitaryProduct => 'Log Sanitary Product';

  @override
  String get sanitaryEntrySheet_setReminderDuration =>
      'Définir la durée du rappel';

  @override
  String sanitaryEntrySheet_maxDuration(int hours) {
    return 'Durée maximale: $hours heures';
  }

  @override
  String get sanitaryEntrySheet_futureLogTimeError =>
      'Un suivi ne peut pas être dans le futur.';

  @override
  String get sanitaryEntrySheet_pastReminderTimeError =>
      'La fin d\'un rappel ne peut pas être dans le passé.';

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
  String get customSymptomDialog_newSymptom => 'Nouveau symptôme';

  @override
  String get customSymptomDialog_enterCustomSymptom =>
      'Please enter a custom symptom';

  @override
  String get customSymptomDialog_temporarySymptom => 'Symptôme temporaire';
}
