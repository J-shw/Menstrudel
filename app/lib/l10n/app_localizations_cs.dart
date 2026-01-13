// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Menstrudel';

  @override
  String get nextDue => 'Další termín';

  @override
  String get ongoing => 'Probíhající';

  @override
  String get overdue => 'Zpožděný';

  @override
  String get total => 'Celkově';

  @override
  String get shortest => 'Nejkratší';

  @override
  String get longest => 'Nejdelší';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Čas';

  @override
  String get start => 'Začátek';

  @override
  String get end => 'Konec';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get day => 'Den';

  @override
  String get days => 'Dny';

  @override
  String get hours => 'Hodiny';

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
  String get logs => 'Záznamy';

  @override
  String get insights => 'Statistiky';

  @override
  String get edit => 'Upravit';

  @override
  String get delete => 'Smazat';

  @override
  String get clear => 'Vyčistit';

  @override
  String get save => 'Uložit';

  @override
  String get import => 'Importovat';

  @override
  String get ok => 'Ok';

  @override
  String get confirm => 'Potvrdit';

  @override
  String get set => 'Nastavit';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get cancel => 'Zrušit';

  @override
  String get select => 'Vybrat';

  @override
  String get close => 'Zavřít';

  @override
  String get reset => 'Restartovat';

  @override
  String get add => 'Přidat';

  @override
  String get notSet => 'Nenastavené';

  @override
  String get removed => 'Smazáno';

  @override
  String get totalLogs => 'Všechny záznamy';

  @override
  String get note => 'Poznámka';

  @override
  String get systemDefault => 'Podle systému';

  @override
  String get flow => 'Tok';

  @override
  String get type => 'Typ';

  @override
  String get other => 'Jiný';

  @override
  String get navBar_insights => 'Statistiky';

  @override
  String get navBar_logs => 'Záznamy';

  @override
  String get navBar_sanitary => 'Pomůcky';

  @override
  String get navBar_sexActivity => 'Sexuální aktivita';

  @override
  String get navBar_pill => 'Pilulky';

  @override
  String get navBar_larc => 'DPRA';

  @override
  String get navBar_settings => 'Nastavení';

  @override
  String get flowIntensity_none => 'Žádná';

  @override
  String get flowIntensity_spotting => 'Špinění';

  @override
  String get flowIntensity_light => 'Lehké';

  @override
  String get flowIntensity_moderate => 'Střední';

  @override
  String get flowIntensity_heavy => 'Vysoké';

  @override
  String get builtInSymptom_acne => 'Akné';

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
  String get painLevel_none => 'Žádná';

  @override
  String get painLevel_mild => 'Lehká';

  @override
  String get painLevel_moderate => 'Střední';

  @override
  String get painLevel_severe => 'Těžká';

  @override
  String get pain_unbearable => 'Nesnesitelná';

  @override
  String get larcType_iud => 'Nitroděložní tělísko';

  @override
  String get larcType_implant => 'Implantát';

  @override
  String get larcType_injection => 'Injekce';

  @override
  String get larcType_ring => 'Vaginální kroužek';

  @override
  String get larcType_patch => 'Náplast';

  @override
  String get sanitaryProduct_tampon => 'Tampon';

  @override
  String get sanitaryProduct_pad => 'Vložka';

  @override
  String get sanitaryProduct_menstrualCup => 'Menstruační kalíšek';

  @override
  String get sanitaryProduct_periodUnderwear => 'Menstruační kalhotky';

  @override
  String get sanitaryProducts_mostUsed => 'Nejvíce používané';

  @override
  String get sanitaryProducts_usageTrend => 'Trend používání';

  @override
  String get sexProtection_none => 'Žádná';

  @override
  String get sexProtection_barrier => 'Bariérová';

  @override
  String get sexProtection_hormonal => 'Hormonální';

  @override
  String get sexProtection_natural => 'Naturální';

  @override
  String get sexProtection_permanent => 'Permanentní';

  @override
  String get sexType_vaginal => 'Vaginální';

  @override
  String get sexType_anal => 'Anální';

  @override
  String get sexType_oral => 'Orální';

  @override
  String get sexType_manual => 'Manuální';

  @override
  String get sexParticipation_solo => 'Sólo';

  @override
  String get sexParticipation_partner => 'Partner';

  @override
  String get sexParticipation_group => 'Skupina';

  @override
  String get userGoal_general => 'General Health';

  @override
  String get userGoal_sexual => 'Sexual Health';

  @override
  String get userGoal_conceive => 'Trying to Conceive';

  @override
  String get userGoal_avoid => 'Avoiding Pregnancy';

  @override
  String get dayOfWeek_monday => 'Pondělí';

  @override
  String get dayOfWeek_tuesday => 'Úterý';

  @override
  String get dayOfWeek_wednesday => 'Středa';

  @override
  String get dayOfWeek_thursday => 'Čtvrtek';

  @override
  String get dayOfWeek_friday => 'Pátek';

  @override
  String get dayOfWeek_saturday => 'Sobota';

  @override
  String get dayOfWeek_sunday => 'Neděle';

  @override
  String get error_valueMustbePositive => 'Hodnota musí být kladná';

  @override
  String get error_valueCannotBeNull => 'Hodnota nesmí být prázdná';

  @override
  String get notification_periodTitle => 'Blížící se menstruace';

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
  String get notification_periodOverdueTitle => 'Opožděná menstruace';

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
  String get notification_pillTitle => 'Připomenutí pilulky';

  @override
  String get notification_pillBody => 'Nezapomeňte si dnes vzít pilulky.';

  @override
  String get notification_larcTitle => 'Upomínka LARC';

  @override
  String notification_larcBody(String type, int days) {
    return '.';
  }

  @override
  String get notification_loggingReminderTitle => 'Upozornění záznamu';

  @override
  String get notification_loggingReminderBody =>
      'Klikněte a zaznamenejte svůj dnešní tok.';

  @override
  String get notification_SanitaryProductReminderTitle =>
      'Upozornění na menstruační pomůcky';

  @override
  String get notification_SanitaryProductReminderBody =>
      'Nezapomeňte si vyměnit menstruační pomůcku.';

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
      'This helps us tailor the insights you see.';

  @override
  String get onboardingScreen_getStarted => 'Get Started';

  @override
  String get mainScreen_insightsPageTitle => 'Vaše statistiky';

  @override
  String get mainSceen_sexActivityPageTitle => 'Sexuální aktivita';

  @override
  String get mainScreen_sanitaryPageTitle => 'Menstruační pomůcky';

  @override
  String get mainScreen_pillsPageTitle => 'Pilulky';

  @override
  String get mainScreen_LarcsPageTitle => 'LARC';

  @override
  String get mainScreen_settingsPageTitle => 'Nastavení';

  @override
  String get mainScreen_tooltipLogPeriod => 'Zapsání menstruace';

  @override
  String get insightsScreen_errorPrefix => 'Chyba:';

  @override
  String get insightsScreen_noDataAvailable => 'Žádná data k dispozici.';

  @override
  String get logsScreen_calculatingPrediction => 'Počítání předpovědi...';

  @override
  String get logScreen_logAtLeastTwoPeriods =>
      'Zapište nejméně dvě menstruace pro odhadnutí dalšího cyklu.';

  @override
  String get logScreen_nextPeriodEstimate => 'Odhad další menstruace';

  @override
  String get logScreen_periodDueToday => 'Dnes má začít menstruace';

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
      'Dnešní pilulka je označena jako užitá.';

  @override
  String get pillScreen_pillForTodayMarkedAsSkipped =>
      'Dnešní pilulka je označena jako přeskočena.';

  @override
  String get larcScreen_noLarcRecordsFound => 'Žádné záznamy o LARC nalezeny.';

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
      'Aktuálně monitorované záznamy LARC.';

  @override
  String get larcScreen_noActiveRecords =>
      'V současné době není aktivní LARC. Prosím přidejte nový záznam.';

  @override
  String get larcScreen_noHistoryRecords =>
      'Nebyly nalezeny žádné minulé ani prošlé záznamy LARC.';

  @override
  String get sanitaryProductsScreen_noSanitaryProductRecordsFound =>
      'Žádné záznamy o menstruačních pomůckách nebyly nalezeny.';

  @override
  String sanitaryProductsScreen_history(int history) {
    return 'History ($history)';
  }

  @override
  String get sanitaryProductsScreen_noHistoryRecords =>
      'Žádné dřívější záznamy o menstruačních pomůckách nebyly nalezeny.';

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
      'Žádný záznam o sexuální aktivitě nalezen.';

  @override
  String sexActivityScreen_history(int history) {
    return 'History ($history)';
  }

  @override
  String get settingsScreen_selectHistoryView => 'Zvolte zobrazení historie';

  @override
  String get settingsScreen_deleteRegimen_question => 'Odstranit režim?';

  @override
  String get settingsScreen_deleteRegimenDescription =>
      'Tato akce vymaže vaše aktuální nastavení o balíčku pilulek a všechny záznamy o pilulkách. Tohle nemůže být vráceno.';

  @override
  String get settingsScreen_allLogsHaveBeenCleared =>
      'Všechny zápisy byly vymazány.';

  @override
  String get settingsScreen_clearAllLogs_question => 'Smazat všechny záznamy?';

  @override
  String get settingsScreen_deleteAllLogsDescription =>
      'Tohle permanentně smaže všechny vaše záznamy o menstruaci. Nastavení aplikace zůstane beze změny.';

  @override
  String get settingsScreen_appearance => 'Vzhled';

  @override
  String get settingsScreen_historyViewStyle => 'Styl zobrazení historie';

  @override
  String get settingsScreen_appTheme => 'Motiv aplikace';

  @override
  String get settingsScreen_themeLight => 'Světlý';

  @override
  String get settingsScreen_themeDark => 'Tmavý';

  @override
  String get settingsScreen_themeSystem => 'Systémový';

  @override
  String get settingsScreen_dynamicTheme => 'Dynamický motiv';

  @override
  String get settingsScreen_useWallpaperColors =>
      'Použít barvy z tapety telefonu';

  @override
  String get settingsScreen_themeColor => 'Barva motivu';

  @override
  String get settingsScreen_pickAColor => 'Vyberte barvu';

  @override
  String get settingsScreen_view => 'Zobrazení';

  @override
  String get settingsScreen_birthControl => 'Antikoncepce';

  @override
  String get settingsScreen_enablePillTracking => 'Zapnout sledování pilulek';

  @override
  String get settingsScreen_pillDescription =>
      'Sledujte denní užívání pilulek a nastavte si připomenutí.';

  @override
  String get settingsScreen_setUpPillRegimen => 'Nastavte si režim pilulek';

  @override
  String get settingsScreen_trackYourDailyPillIntake =>
      'Sledujte svůj denní příjem pilulek';

  @override
  String get settingsScreen_dailyPillReminder =>
      'Denní připomenutí užívání pilulek';

  @override
  String get settingsScreen_reminderTime => 'Čas připomenutí';

  @override
  String get settingsScreen_periodPredictionAndReminders =>
      'Předpověď menstruace a připomenutí';

  @override
  String get settingsScreen_upcomingPeriodReminder =>
      'Připomenutí na přicházející menstruaci';

  @override
  String get settingsScreen_remindMeBefore => 'Připomenout mi předem';

  @override
  String get settingsScreen_notificationTime => 'Čas oznámení';

  @override
  String get settingsScreen_overduePeriodReminder =>
      'Připomenutí na zpožděnou menstruaci';

  @override
  String get settingsScreen_remindMeAfter => 'Připomenout mi potom';

  @override
  String get settingsScreen_enableLarcTracking => 'Zapnout sledování LARC';

  @override
  String get settingsScreen_larcDescription =>
      'Sledujte dlouhodobě působící reverzibilní antikoncepci (LARC).';

  @override
  String get settingsScreen_larcType => 'Typ LARC';

  @override
  String get settingsScreen_setDuration => 'Nastavit čas trvání';

  @override
  String get settingsScreen_larcDuration => 'Doba platnosti LARC';

  @override
  String get settingsScreen_enableLARCReminder => 'Zapnout připomenutí LARC';

  @override
  String get settingsScreen_currentDuration => 'Aktuální doba trvání';

  @override
  String get settingsScreen_durationInDays => 'Doba trvání (Dny)';

  @override
  String get settingsScreen_LoggingScreen => 'Záznam';

  @override
  String get settingsScreen_enableLoggingReminders =>
      'Zapnout připomenutí záznamu';

  @override
  String get settingsScreen_loggingReminderDescription =>
      'Když zaznamenáte den s krvácením, následující den obdržíte oznámení, abyste zaznamenali svůj stav.';

  @override
  String get settingsScreen_loggingReminderTime => 'Čas upozornění záznamu';

  @override
  String get settingsScreen_defaultSymptoms => 'Výchozí příznaky';

  @override
  String get settingsScreen_defaultSymptomsSubtitle =>
      'Tyto jsou vždy k dispozici při zaznamenávání nových menstruací.\nKlepnutím na existující příznak jej smažete, klepnutím na „+“ přidáte nový.';

  @override
  String settingsScreen_deleteDefaultSymptomQuestion(String symptom) {
    return 'Delete \'$symptom\'?';
  }

  @override
  String get settingsScreen_resetSymptomsList => 'Reset Symptoms List?';

  @override
  String get settingsScreen_resetSymptomsListDescription =>
      'Tohle smaže všechny vaše vlastní příznaky a obnoví původní vestavěný seznam.\n\nVaše existující záznamy se nezmění.';

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
  String get settingsScreen_pillRegimens => 'Režim pilulek';

  @override
  String get settingsScreen_makeActive => 'Nastavit jako aktivní';

  @override
  String get settingsScreen_activeRegimenReminder =>
      'Nastavení připomenutí aktivního režimu';

  @override
  String get settingsScreen_pack => 'Balíček';

  @override
  String get settingsScreen_dataManagement => 'Správa dat';

  @override
  String get settingsScreen_dangerZone => 'Nebezpečná zóna';

  @override
  String get settingsScreen_clearAllLogs => 'Vyčistit všechny záznamy';

  @override
  String get settingsScreen_clearAllLogsSubtitle =>
      'Vymaže celou historii menstruace a příznaků.';

  @override
  String get settingsScreen_clearAllPillData =>
      'Vyčistit všechny data o pilulkách';

  @override
  String get settingsScreen_clearAllPillDataSubtitle =>
      'Vymaže váš režim pilulek a historii užívání.';

  @override
  String get settingsScreen_clearAllPillData_question =>
      'Vyčistit všechny data o pilulkách?';

  @override
  String get settingsScreen_deleteAllPillDataDescription =>
      'Tímto krokem trvale smažete svůj režim užívání pilulek, připomenutí a historii užívání.';

  @override
  String get settingsScreen_allPillDataCleared =>
      'Všechny data o pilulkách byly vyčištěny.';

  @override
  String get settingsScreen_clearAllLarcData => 'Vyčistit všechny data o LARC';

  @override
  String get settingsScreen_clearAllLarcDataSubtitle =>
      'Smaže vaši historii o LARC.';

  @override
  String get settingsScreen_clearAllLarcData_question =>
      'Vyčistit všechny data o LARC?';

  @override
  String get settingsScreen_deleteAllLarcDataDescription =>
      'Tímto trvale smažete svou historii LARC.';

  @override
  String get settingsScreen_allLarcDataCleared =>
      'Všechny data o LARC byly vyčištěny.';

  @override
  String get settingsScreen_clearAllSanitaryData =>
      'Vyčistit všechny data o menstruačních pomůckách';

  @override
  String get settingsScreen_clearAllSanitaryDataSubtitle =>
      'Smaže vaši historii o menstruačních pomůckách.';

  @override
  String get settingsScreen_clearAllSanitaryData_question =>
      'Vyčistit všechny data o menstruačních pomůckách?';

  @override
  String get settingsScreen_deleteAllSanitaryDataDescription =>
      'Tímto trvale smažete svou historii o menstruačních pomůckách.';

  @override
  String get settingsScreen_allSanitaryDataCleared =>
      'Všechny data o menstruačních pomůckách byly vyčištěny.';

  @override
  String get settingsScreen_exportPeriodData =>
      'Exportovat data o menstruacích';

  @override
  String get settingsScreen_exportPillData => 'Exportovat data o pilulkách';

  @override
  String get settingsScreen_exportLarcsData => 'Exportovat data o LARC';

  @override
  String get settingsScreen_exportSanitaryData =>
      'Exportovat data o menstruačních pomůckách';

  @override
  String get settingsScreen_exportDataSubtitle =>
      'Vytvořit zálohovací JSON soubor.';

  @override
  String get settingsScreen_exportSuccessful =>
      'Data byla exportována úspěšně.';

  @override
  String get settingsScreen_exportFailed =>
      'Exportování se pokazilo. Prosím zkuste to znovu.';

  @override
  String get settingsScreen_noDataToExport =>
      'Nebyly nalezeny žádná data k exportování.';

  @override
  String get settingsScreen_exportDataMessage =>
      'Zde je můj export dat z aplikace MenstruDel.';

  @override
  String get settingsScreen_exportDataTitle => 'Exportovat data';

  @override
  String get settingsScreen_importDataTitle => 'Importovat data';

  @override
  String get settingsScreen_importPeriodData =>
      'Importovat data o menstruacích';

  @override
  String get settingsScreen_importPillData => 'Importovat data o pilulkách';

  @override
  String get settingsScreen_importLarcsData => 'Importovat data o LARC';

  @override
  String get settingsScreen_importSanitaryData =>
      'Importovat data o menstruačních pomůckách';

  @override
  String get settingsScreen_importDataSubtitle => 'Přepíše existující data.';

  @override
  String get settingsScreen_importPeriodData_question =>
      'Opravdu chcete importovat data o menstruacích?';

  @override
  String get settingsScreen_importPillData_question =>
      'Opravdu chcete importovat data o pilulkách?';

  @override
  String get settingsScreen_importLarcData_question =>
      'Opravdu chcete importovat data o LARC?';

  @override
  String get settingsScreen_importSanitaryData_question =>
      'Opravdu chcete importovat data o menstruačních pomůckách?';

  @override
  String get settingsScreen_importPeriodDataDescription =>
      'Import dat trvale přepíše všechny vaše stávající záznamy o menstruacích a nastavení menstruace. Tento krok nelze vrátit zpět.';

  @override
  String get settingsScreen_importPillDataDescription =>
      'Import dat trvale přepíše všechny vaši stávající historii o pilulkách. Tento krok nelze vrátit zpět.';

  @override
  String get settingsScreen_importLarcDataDescription =>
      'Import dat trvale přepíše všechny vaši stávající historii o LARC. Tento krok nelze vrátit zpět.';

  @override
  String get settingsScreen_importSanitaryDataDescription =>
      'Import dat trvale přepíše všechny vaši stávající historii o menstruačních pomůckách. Tento krok nelze vrátit zpět.';

  @override
  String get settingsScreen_importSuccessful =>
      'Data byla importována úspěšně!';

  @override
  String get settingsScreen_importFailed =>
      'Importování se pokazilo. Prosím zkuste to znovu.';

  @override
  String get settingsScreen_importInvalidFile =>
      'Neplatný formát souboru nebo struktura dat.';

  @override
  String get settingsScreen_importErrorGeneral =>
      'Importování se pokazilo. Prosím ujistěte se, že je soubor uložen lokálně.';

  @override
  String settingsScreen_importErrorPlatform(String message) {
    return 'Import failed: $message. Please ensure the file is saved on the device and try again.';
  }

  @override
  String get settingsScreen_security => 'Bezpečnost';

  @override
  String get securityScreen_enableBiometricLock => 'Zapnout biometrický zámek';

  @override
  String get securityScreen_enableBiometricLockSubtitle =>
      'Vyžaduje otisk prstu nebo rozpoznání obličeje pro odemknutí aplikace.';

  @override
  String get securityScreen_noBiometricsAvailable =>
      'Nebylo nalezeno žádné heslo, otisk prstu ani rozpoznání obličeje. Nastavte je prosím v nastavení svého zařízení.';

  @override
  String get settingsScreen_preferences => 'Preference';

  @override
  String get preferencesScreen_language => 'Jazyk';

  @override
  String get preferencesScreen_enableSanitaryProductsScreen =>
      'Povolit obrazovku menstruačních pomůcek';

  @override
  String get preferencesScreen_enableSanitaryProductsScreenSubtitle =>
      'Zobrazit kartu menstruačních pomůcek na hlavní navigační liště.';

  @override
  String get preferencesScreen_enableSexActivityScreen =>
      'Povolit obrazovku o sexuální aktivitě';

  @override
  String get preferencesScreen_enableSexActivityScreenSubtitle =>
      'Show the Sex Activity tab on the main navigation bar.';

  @override
  String get preferencesScreen_StartingDayOfWeek => 'Starting Day of the Week';

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
