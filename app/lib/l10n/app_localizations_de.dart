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
  String get nextDue => 'Nächster Fälligkeitstermin';

  @override
  String get ongoing => 'Fortlaufend';

  @override
  String get overdue => 'Überfällig';

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
  String get hours => 'Hours';

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
  String get clear => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get import => 'Importieren';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get set => 'Festlegen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get select => 'Auswählen';

  @override
  String get close => 'Schließen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get notSet => 'Nicht festgelegt';

  @override
  String get removed => 'Removed';

  @override
  String get note => 'Hinweis';

  @override
  String get systemDefault => 'System Standard';

  @override
  String get flow => 'Ausfluss';

  @override
  String get type => 'Type';

  @override
  String get navBar_insights => 'Einblicke';

  @override
  String get navBar_logs => 'Protokolle';

  @override
  String get navBar_sanitary => 'Sanitary';

  @override
  String get navBar_pill => 'Pille';

  @override
  String get navBar_larc => 'LARC';

  @override
  String get navBar_settings => 'Einstellungen';

  @override
  String get flowIntensity_none => 'Keine';

  @override
  String get flowIntensity_spotting => 'Erkennen';

  @override
  String get flowIntensity_light => 'Hell';

  @override
  String get flowIntensity_moderate => 'Mäßig';

  @override
  String get flowIntensity_heavy => 'Schwer';

  @override
  String get builtInSymptom_acne => 'Akne';

  @override
  String get builtInSymptom_backPain => 'Rückenschmerzen';

  @override
  String get builtInSymptom_bloating => 'Blähungen';

  @override
  String get builtInSymptom_cramps => 'Krämpfe';

  @override
  String get builtInSymptom_fatigue => 'Müdigkeit';

  @override
  String get builtInSymptom_headache => 'Kopfschmerzen';

  @override
  String get builtInSymptom_moodSwings => 'Stimmungsschwankungen';

  @override
  String get builtInSymptom_nausea => 'Übelkeit';

  @override
  String get painLevel_title => 'Schmerzgrad';

  @override
  String get painLevel_none => 'Keine';

  @override
  String get painLevel_mild => 'Mild';

  @override
  String get painLevel_moderate => 'Mäßig';

  @override
  String get painLevel_severe => 'Schwerwiegend';

  @override
  String get pain_unbearable => 'Unerträglich';

  @override
  String get larcType_iud => 'Spirale';

  @override
  String get larcType_implant => 'Implantat';

  @override
  String get larcType_injection => 'Injektion';

  @override
  String get larcType_ring => 'Ring';

  @override
  String get larcType_patch => 'Patch';

  @override
  String get sanitaryProduct_tampon => 'Tampon';

  @override
  String get sanitaryProduct_pad => 'Pad';

  @override
  String get sanitaryProduct_menstrualCup => 'Menstrual Cup';

  @override
  String get sanitaryProduct_periodUnderwear => 'Period Underwear';

  @override
  String get error_valueMustbePositive => 'Der Wert muss positiv sein';

  @override
  String get error_valueCannotBeNull => 'Der Wert darf nicht null sein';

  @override
  String get notification_periodTitle => 'Periode nähert sich';

  @override
  String notification_periodBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deine nächste Periode startet voraussichtlich in $count Tagen.',
      one: 'Deine nächste Periode startet voraussichtlich in 1 Tag',
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
      other: 'Deine nächste Periode ist seit $count Tagen überfällig.',
      one: 'Deine nächste Periode ist seit 1 Tag überfällig.',
    );
    return '$_temp0';
  }

  @override
  String get notification_pillTitle => 'Pillenerinnerung';

  @override
  String get notification_pillBody =>
      'Vergiss nicht, Deine Pille für heute einzunehmen.';

  @override
  String get notification_larcTitle => 'LARC-Erinnerung';

  @override
  String notification_larcBody(String type, int days) {
    return '$type muss in $days Tagen erneuert werden.';
  }

  @override
  String get notification_SanitaryProductReminderTitle =>
      'Sanitary Product Reminder';

  @override
  String get notification_SanitaryProductReminderBody =>
      'Remember to change your product.';

  @override
  String get mainScreen_insightsPageTitle => 'Deine Erkenntnisse';

  @override
  String get mainScreen_sanitaryPageTitle => 'Sanitary Products';

  @override
  String get mainScreen_pillsPageTitle => 'Pille';

  @override
  String get mainScreen_LarcsPageTitle => 'LARC';

  @override
  String get mainScreen_settingsPageTitle => 'Einstellungen';

  @override
  String get mainScreen_tooltipLogPeriod => 'Periode Eintragen';

  @override
  String get insightsScreen_errorPrefix => 'Fehler:';

  @override
  String get insightsScreen_noDataAvailable => 'Keine Daten verfügbar.';

  @override
  String get logsScreen_calculatingPrediction => 'Berechnung der Vorhersage...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Protokolliere mindestens zwei Perioden, um den nächsten Zyklus zu schätzen.';

  @override
  String get logScreen_nextPeriodEstimate => 'Nächste Periode voraussichtlich';

  @override
  String get logScreen_periodDueToday => 'Heute fällige Periode';

  @override
  String logScreen_periodOverdueBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Periode $count Tage überfällig',
      one: 'Periode 1 Tag überfällig',
    );
    return '$_temp0';
  }

  @override
  String get pillScreen_pillForTodayMarkedAsTaken =>
      'Pille für heute als eingenommen markiert.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Pille für heute als ausgelassen markiert.';

  @override
  String get larcScreen_noLarcRecordsFound => 'Keine LARC-Datensätze gefunden.';

  @override
  String larcScreen_history(int history) {
    return 'Verlauf ($history)';
  }

  @override
  String larcScreen_activeLarcs(int activeCount) {
    return 'Aktive LARC ($activeCount)';
  }

  @override
  String get larcScreen_activeLarcsDescription =>
      'Derzeit überwachte LARC-Einträge.';

  @override
  String get larcScreen_noActiveRecords =>
      'Derzeit ist kein LARC aktiv. Bitte einen neuen Eintrag vornehmen.';

  @override
  String get larcScreen_noHistoryRecords =>
      'Es wurden keine früheren oder überfälligen LARC-Datensätze gefunden.';

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
  String get settingsScreen_selectHistoryView =>
      'Vergangenheitsansicht auswählen';

  @override
  String get settingsScreen_deleteRegimen_question => 'Kuren löschen?';

  @override
  String get settingsScreen_deleteRegimenDescription =>
      'Dies wird deine aktuellen Pillenverpackungseinstellungen und alle zugehörigen Pillenaufzeichnungen löschen. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get settingsScreen_allLogsHaveBeenCleared =>
      'Alle Protokolle wurden gelöscht.';

  @override
  String get settingsScreen_clearAllLogs_question => 'Alle Protokolle löschen?';

  @override
  String get settingsScreen_deleteAllLogsDescription =>
      'Dadurch werden alle Deine Periodenprotokolle dauerhaft gelöscht. Deine App-Einstellungen bleiben davon unberührt.';

  @override
  String get settingsScreen_appearance => 'Aussehen';

  @override
  String get settingsScreen_historyViewStyle => 'Art der Vergangenheitsansicht';

  @override
  String get settingsScreen_appTheme => 'App-Thema';

  @override
  String get settingsScreen_themeLight => 'Hell';

  @override
  String get settingsScreen_themeDark => 'Dunkel';

  @override
  String get settingsScreen_themeSystem => 'System';

  @override
  String get settingsScreen_dynamicTheme => 'Dynamisches Thema';

  @override
  String get settingsScreen_useWallpaperColors => 'Nutze Hintergrundfarben';

  @override
  String get settingsScreen_themeColor => 'Themenfarbe';

  @override
  String get settingsScreen_pickAColor => 'Eine Farbe auswählen';

  @override
  String get settingsScreen_view => 'Ansicht';

  @override
  String get settingsScreen_birthControl => 'Empfängnisverhütung';

  @override
  String get settingsScreen_enablePillTracking => 'Pillentracking einschalten';

  @override
  String get settingsScreen_pillDescription =>
      'Erfasse Deine tägliche Einnahme von Tabletten und erhalte Erinnerungen.';

  @override
  String get settingsScreen_setUpPillRegimen => 'Set Up Pill Regimen';

  @override
  String get settingsScreen_trackYourDailyPillIntake =>
      'Tägliche Pilleneinnahme tracken';

  @override
  String get settingsScreen_dailyPillReminder => 'Tägliche Pillenerinnerung';

  @override
  String get settingsScreen_reminderTime => 'Erinnerungszeit';

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
  String get settingsScreen_overduePeriodReminder =>
      'Erinnerung bei überfälliger Periode';

  @override
  String get settingsScreen_remindMeAfter => 'Erinnere mich in';

  @override
  String get settingsScreen_enableLarcTracking => 'LARC-Verfolgung aktivieren';

  @override
  String get settingsScreen_larcDescription =>
      'Erfassung langwirksamer reversibler Verhütungsmittel (LARCs).';

  @override
  String get settingsScreen_larcType => 'LARC Typ';

  @override
  String get settingsScreen_setDuration => 'Dauer festlegen';

  @override
  String get settingsScreen_larcDuration => 'Dauer des LARC-Ersatzes';

  @override
  String get settingsScreen_enableLARCReminder => 'LARC-Erinnerung aktivieren';

  @override
  String get settingsScreen_currentDuration => 'Aktuelle Dauer';

  @override
  String get settingsScreen_durationInDays => 'Dauer (Tage)';

  @override
  String get settingsScreen_LoggingScreen => 'Protokollieren';

  @override
  String get settingsScreen_defaultSymptoms => 'Standardsymptome';

  @override
  String get settingsScreen_defaultSymptomsSubtitle =>
      'Diese sind immer sichtbar, wenn eine neue Periode eingetragen wird. Wähle ein bestehendes Symptom, um es zu löschen oder \'+\' um ein neues hinzuzufügen.';

  @override
  String settingsScreen_deleteDefaultSymptomQuestion(String symptom) {
    return '\'$symptom\' löschen?';
  }

  @override
  String get settingsScreen_resetSymptomsList => 'Symptomliste zurücksetzen?';

  @override
  String get settingsScreen_resetSymptomsListDescription => '';

  @override
  String settingsScreen_deleteDefaultSymptomDescription(
    String symptom,
    num usageCount,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      usageCount,
      locale: localeName,
      other:
          'Es gibt $usageCount Periodenprotokolle mit diesem Symptom!\nDiese Protokolle werden nicht geändert.',
      one:
          'Es gibt bereits 1 Periodenprotokoll mit diesem Symptom!\nDieses Protokoll wird nicht geänder.',
      zero: 'Derzeit gibt es keine Periodenprotokolle mit diesem Symptom!',
    );
    return '\'$symptom\' ist beim Protokollieren eines Zeitraums nicht mehr verfügbar.\n\n$_temp0';
  }

  @override
  String get settingsScreen_pillRegimens => 'Pill Regimens';

  @override
  String get settingsScreen_makeActive => 'Als aktiv festlegen';

  @override
  String get settingsScreen_activeRegimenReminder =>
      'Einstellungen für aktive Kurerinnerungen';

  @override
  String get settingsScreen_pack => 'Pack';

  @override
  String get settingsScreen_dataManagement => 'Datenverwaltung';

  @override
  String get settingsScreen_dangerZone => 'Gefahrenbereich';

  @override
  String get settingsScreen_clearAllLogs => 'Alle Protokolle löschen';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Löscht den gesamten Verlauf deiner Periode und Symptome.';

  @override
  String get settingsScreen_clearAllPillData => 'Clear All Pill Data';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Removes your pill regimen and intake history.';

  @override
  String get settingsScreen_clearAllPillData_question =>
      'Alle Pillen-Daten löschen?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'This will permanently delete your pill regimen, reminders, and intake history. This action cannot be undone.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'Alle Pille-Daten wurden gelöscht.';

  @override
  String get settingsScreen_clearAllLarcData => 'Alle LARC-Daten löschen';

  @override
  String get settingsScreen_clearAllLarcDataSubtitle =>
      'Löscht deinen LARC-Verlauf.';

  @override
  String get settingsScreen_clearAllLarcData_question =>
      'Alle LARC-Daten löschen?';

  @override
  String get settingsScreen_deleteAllLarcDataDescription =>
      'Dadurch wird Dein LARC-Verlauf dauerhaft gelöscht.';

  @override
  String get settingsScreen_allLarcDataCleared =>
      'Alle LARC-Daten wurden gelöscht.';

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
  String get settingsScreen_exportPeriodData => 'Periodendaten exportieren';

  @override
  String get settingsScreen_exportPillData => 'Periodendaten exportieren';

  @override
  String get settingsScreen_exportLarcsData => 'LARCs-Daten exportieren';

  @override
  String get settingsScreen_exportSanitaryData =>
      'Export Sanitary Products Data';

  @override
  String get settingsScreen_exportDataSubtitle =>
      'Erstelle eine JSON Backup Datei.';

  @override
  String get settingsScreen_exportSuccessful => 'Daten erfolgreich exportiert.';

  @override
  String get settingsScreen_exportFailed =>
      'Export fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get settingsScreen_noDataToExport =>
      'Keine Daten zum Exportieren gefunden.';

  @override
  String get settingsScreen_exportDataMessage =>
      'Hier ist mein MenstruDel Datenexport.';

  @override
  String get settingsScreen_exportDataTitle => 'Daten exportieren';

  @override
  String get settingsScreen_importDataTitle => 'Daten importieren';

  @override
  String get settingsScreen_importPeriodData => 'Periodendaten importieren';

  @override
  String get settingsScreen_importPillData => 'Periodendaten importieren';

  @override
  String get settingsScreen_importLarcsData => 'LARCs-Daten importieren';

  @override
  String get settingsScreen_importSanitaryData =>
      'Import Sanitary Products Data';

  @override
  String get settingsScreen_importDataSubtitle =>
      'Überschreibt vorhandene Daten.';

  @override
  String get settingsScreen_importPeriodData_question =>
      'Bist du sicher, dass du die Periodendaten importieren möchtest?';

  @override
  String get settingsScreen_importPillData_question =>
      'Willst du wirklich die Pille-Daten importieren?';

  @override
  String get settingsScreen_importLarcData_question =>
      'Willst du wirklich die Pille-Daten importieren?';

  @override
  String get settingsScreen_importSanitaryData_question =>
      'Are you sure you want to import Sanitary Products Data?';

  @override
  String get settingsScreen_importPeriodDataDescription =>
      'Durch den Import von Daten werden alle bisherigen Periodenprotokolle und Periodeneinstellungen dauerhaft überschrieben. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get settingsScreen_importPillDataDescription =>
      'Durch den Import von Daten werden alle bisherigen Pillen-Daten dauerhaft überschrieben. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get settingsScreen_importLarcDataDescription =>
      'Importing data will permanently overwrite all your existing LARC history. This cannot be undone.';

  @override
  String get settingsScreen_importSanitaryDataDescription =>
      'Importing data will permanently overwrite all your existing sanitary product history. This cannot be undone.';

  @override
  String get settingsScreen_importSuccessful => 'Daten erfolgreich importiert!';

  @override
  String get settingsScreen_importFailed =>
      'Datenimport fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get settingsScreen_importInvalidFile =>
      'Ungültiges Dateiformat oder ungültige Datenstruktur.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Daten konnten nicht importiert werden. Bitte stelle sicher, dass die Datei lokal gespeichert ist.';

  @override
  String settingsScreen_importErrorPlatform(String message) {
    return 'Import fehlgeschlagen: $message. Bitte stelle sicher, dass die Datei auf dem Gerät gespeichert ist und versuche es erneut.';
  }

  @override
  String get settingsScreen_security => 'Sicherheit';

  @override
  String get securityScreen_enableBiometricLock =>
      'Biometrische Sperre aktivieren';

  @override
  String get securityScreen_enableBiometricLockSubtitle =>
      'Zum Öffnen der App ist eine Fingerabdruck- oder Gesichtserkennung erforderlich.';

  @override
  String get securityScreen_noBiometricsAvailable =>
      'Es wurde kein Passcode, Fingerabdruck oder Face ID gefunden. Bitte lege einen in den Einstellungen des Geräts fest.';

  @override
  String get settingsScreen_preferences => 'Einstellungen';

  @override
  String get preferencesScreen_language => 'Sprache';

  @override
  String get preferencesScreen_enableSanitaryProductsScreen =>
      'Enable Sanitary Products Screen';

  @override
  String get preferencesScreen_enableSanitaryProductsScreenSubtitle =>
      'Show the Sanitary Products tab on the main navigation bar.';

  @override
  String get settingsScreen_about => 'Über';

  @override
  String get aboutScreen_version => 'Version';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Quellcode und Fehlerverfolgung';

  @override
  String get aboutScreen_share => 'Teilen';

  @override
  String get aboutScreen_shareSubtitle => 'Teile die App mit Freunden';

  @override
  String get aboutScreen_urlError => 'Der Link konnte nicht geöffnet werden.';

  @override
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods =>
      'Es sind mindestens zwei Zyklen erforderlich, um Abweichungen zu zeigen.';

  @override
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance =>
      'Zyklus- und Periodenabweichung';

  @override
  String get cycleLengthVarianceWidget_averageCycle =>
      'Durchschnittlicher Zyklus';

  @override
  String get cycleLengthVarianceWidget_averagePeriod =>
      'Durchschnittliche Periode';

  @override
  String get cycleLengthVarianceWidget_period => 'Periode';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Zyklus';

  @override
  String get flowIntensityWidget_flowIntensityBreakdown =>
      'Aufschlüsselung der Abflussintensität';

  @override
  String get flowIntensityWidget_noFlowDataLoggedYet =>
      'Es wurden noch keine Schmerzdaten erfasst.';

  @override
  String get painLevelWidget_noPainDataLoggedYet =>
      'Es wurden noch keine Schmerzdaten erfasst.';

  @override
  String get painLevelWidget_painLevelBreakdown =>
      'Schmerzgrad-Aufschlüsselung';

  @override
  String get monthlyFlowChartWidget_noDataToDisplay =>
      'Keine Daten zum Anzeigen.';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatterns => 'Zyklusverlaufsmuster';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription =>
      'Jede Linie stellt einen vollständigen Zyklus dar';

  @override
  String get symptomFrequencyWidget_noSymptomsLoggedYet =>
      'Noch keine Symptome erfasst.';

  @override
  String get symptomFrequencyWidget_mostCommonSymptoms => 'Häufigste Symptome';

  @override
  String get yearHeatMapWidget_yearlyOverview => 'Jahresübersicht';

  @override
  String get journalViewWidget_logYourFirstPeriod =>
      'Trage deine erste Periode ein.';

  @override
  String get listViewWidget_noPeriodsLogged =>
      'Es wurden noch keine Perioden protokolliert.\nDrücke auf die Schaltfläche „+“, um eine hinzuzufügen.';

  @override
  String get listViewWidget_confirmDelete => 'Löschen bestätigen';

  @override
  String get listViewWidget_confirmDeleteDescription =>
      'Willst du diesen Eintrag wirklich löschen?';

  @override
  String get emptyPillStateWidget_noPillRegimenFound =>
      'No pill regimen found.';

  @override
  String get emptyPillStateWidget_noPillRegimenFoundDescription =>
      'Um mit der Nachverfolgung zu beginnen, kannst du deine Pillenpackung in den Einstellungen einrichten.';

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
  String get pillStatus_undo => 'Rückgängig';

  @override
  String get pillStatus_skip => 'Überspringen';

  @override
  String get pillStatus_markAsTaken => 'Als genommen notieren';

  @override
  String pillStatus_packStartInFuture(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Deine nächste Pillenpackung beginnt am $dateString.';
  }

  @override
  String get regimenSetupWidget_setUpPillRegimen => 'Pilleneinnahme festlegen';

  @override
  String get regimenSetupWidget_packName => 'Verpackungsname';

  @override
  String get regimenSetupWidget_pleaseEnterAName =>
      'Bitte einen Namen eingeben';

  @override
  String get regimenSetupWidget_activePills => 'Aktive Pillen';

  @override
  String get regimenSetupWidget_enterANumber => 'Eine Zahl eingeben';

  @override
  String get regimenSetupWidget_placeboPills => 'Placebo-Pillen';

  @override
  String get regimenSetupWidget_firstDayOfThisPack => 'First Day of This Pack';

  @override
  String get symptomEntrySheet_logYourDay => 'Protokolliere Deinen Tag';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Symptome (optional)';

  @override
  String get periodDetailsSheet_symptoms => 'Symptome';

  @override
  String get periodDetailsSheet_flow => 'Ausfluss';

  @override
  String get larcEntrySheet_logLARCDetails => 'LARC-Details protokollieren';

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
      other: 'Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String get customSymptomDialog_newSymptom => 'Neues Symptom';

  @override
  String get customSymptomDialog_enterCustomSymptom =>
      'Please enter a custom symptom';

  @override
  String get customSymptomDialog_temporarySymptom => 'Vorübergehendes Symptom';
}
