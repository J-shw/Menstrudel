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
  String get next => 'Další';

  @override
  String get back => 'Zpět';

  @override
  String get today => 'Today';

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
      other: '$count Dny',
      one: '$count Den',
    );
    return '$_temp0';
  }

  @override
  String monthCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Měsíce',
      one: '$count Měsíc',
    );
    return '$_temp0';
  }

  @override
  String yearCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Roky',
      one: '$count Rok',
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
  String get navBar_logs => 'Záznamy';

  @override
  String get navBar_sanitary => 'Pomůcky';

  @override
  String get navBar_sexActivity => 'Sexuální aktivita';

  @override
  String get navBar_pill => 'Pilulky';

  @override
  String get navBar_reversibleContraceptive => 'Contraceptives';

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
  String get userGoal_general => 'Celkový zdravotní stav';

  @override
  String get userGoal_sexual => 'Sexuální zdraví';

  @override
  String get userGoal_conceive => 'Snaha o otěhotnění';

  @override
  String get userGoal_avoid => 'Zabránění těhotenství';

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
  String get cyclePhase_menstruation => 'On Period';

  @override
  String get cyclePhase_follicular => 'Pre-Ovulation';

  @override
  String get cyclePhase_ovulation => 'Peak Fertility';

  @override
  String get cyclePhase_luteal => 'Post-Ovulation';

  @override
  String get cyclePhase_late => 'Late Period';

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
      other: 'Předpokládaný začátek další menstruace je za $count dní.',
      one: 'Předpokládaný začátek další menstruace je za 1 den.',
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
      other: 'Vaše další menstruace má být opožděná o $count dní.',
      one: 'Vaše další menstruace má být opožděná o jeden den.',
    );
    return '$_temp0';
  }

  @override
  String get notification_pillTitle => 'Připomenutí pilulky';

  @override
  String get notification_pillBody => 'Nezapomeňte si dnes vzít pilulky.';

  @override
  String get notification_reversibleContraceptiveTitle =>
      'Reversible Contraceptive Reminder';

  @override
  String notification_reversibleContraceptiveBody(String type, int days) {
    return '$type is due for renewal in $days days.';
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
  String get onboardingScreen_welcomeToMenstrudel => 'Vítejte v Menstrudel';

  @override
  String get onboardingScreen_welcomeToMenstrudelDescription =>
      'Soukromá aplikace pro sledování cyklu, která funguje bez internetu.';

  @override
  String get onboardingScreen_profileTitle => 'O vás';

  @override
  String get onboardingScreen_profileName => 'Jak vám máme říkat?';

  @override
  String get onboardingScreen_profileDate => 'Datum narození (volitelné)';

  @override
  String get onboardingScreen_profileDatePlaceholder =>
      'Klikněte pro zadání data narození';

  @override
  String get onboardingScreen_goalTitle => 'Co je váš cíl?';

  @override
  String get onboardingScreen_goalDescription =>
      'This helps tailor the insights you see.';

  @override
  String onboardingScreen_contraceptionHint(String sectionName) {
    return 'Note: You can enable Pill or LARC tracking later in the app settings under \'$sectionName\' if wanted.';
  }

  @override
  String get onboardingScreen_getStarted => 'Začínáme';

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
  String get mainSceen_sexActivityPageTitle => 'Sexuální aktivita';

  @override
  String get mainScreen_sanitaryPageTitle => 'Menstruační pomůcky';

  @override
  String get mainScreen_pillsPageTitle => 'Pilulky';

  @override
  String get mainScreen_reversibleContraceptivesPageTitle =>
      'Reversible Contraceptives';

  @override
  String get mainScreen_settingsPageTitle => 'Nastavení';

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
      other: 'Vaše další menstruace je opožděná o $count dní',
      one: 'Vaše další menstruace je opožděná o jeden den.',
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
    return 'Active Reversible Contraceptives ($activeCount)';
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
      'Žádné záznamy o menstruačních pomůckách nebyly nalezeny.';

  @override
  String sanitaryProductsScreen_history(int history) {
    return 'Historie ($history)';
  }

  @override
  String get sanitaryProductsScreen_noHistoryRecords =>
      'Žádné dřívější záznamy o menstruačních pomůckách nebyly nalezeny.';

  @override
  String sanitaryProductsScreen_activeProduct(String activeType) {
    return 'Aktivní $activeType';
  }

  @override
  String sanitaryProductsScreen_changeDueAt(String time) {
    return 'K výměně v $time';
  }

  @override
  String get sexActivityScreen_noSexActivityRecordsFound =>
      'Žádný záznam o sexuální aktivitě nalezen.';

  @override
  String sexActivityScreen_history(int history) {
    return 'Historie ($history)';
  }

  @override
  String get settingsScreen_profile => 'Profil';

  @override
  String get settingsScreen_name => 'Jméno';

  @override
  String get settingsScreen_birthDate => 'Datum narození';

  @override
  String get settingsScreen_notSet => 'Nenastaveno';

  @override
  String get settingsScreen_appGoal => 'Cíl aplikace';

  @override
  String get settingsScreen_profileUpdated => 'Profil byl úspěšně aktualizován';

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
  String get settingsScreen_enableReversibleContraceptiveTracking =>
      'Enable Reversible Contraceptive Tracking';

  @override
  String get settingsScreen_reversibleContraceptiveDescription =>
      'Track Reversible Contraceptives.';

  @override
  String get settingsScreen_reversibleContraceptive =>
      'Reversible Contraceptive Type';

  @override
  String get settingsScreen_setDuration => 'Nastavit čas trvání';

  @override
  String get settingsScreen_reversibleContraceptiveDuration =>
      'Reversible Contraceptive Replacement Duration';

  @override
  String get settingsScreen_enableReversibleContraceptiveReminder =>
      'Enable Reversible Contraceptive Reminder';

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
    return 'Smazat \'$symptom\'?';
  }

  @override
  String get settingsScreen_resetSymptomsList => 'Obnovit seznam příznaků?';

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
          'Jsou zde$usageCount záznamy menstruace s tímto příznakem!\nTyto záznamy nebudou změněny.',
      one:
          'V současné době je jeden záznam menstruace s tímto příznakem!\nTento záznam nebude změněn.',
      zero:
          'V současné době nejsou žádné záznamy menstruací s tímto příznakem!',
    );
    return '\'$symptom\' už nebude dostupný při záznamu menstruace.\n\n$_temp0';
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
  String get settingsScreen_clearAllReversibleContraceptiveData =>
      'Clear All Reversible Contraceptive Data';

  @override
  String get settingsScreen_clearAllReversibleContraceptiveDataSubtitle =>
      'Removes your reversible contraceptives history.';

  @override
  String get settingsScreen_clearAllReversibleContraceptiveData_question =>
      'Clear All Reversible Contraceptive Data?';

  @override
  String get settingsScreen_deleteAllReversibleContraceptiveDataDescription =>
      'This will permanently delete your Reversible Contraceptive history.';

  @override
  String get settingsScreen_allReversibleContraceptiveDataCleared =>
      'All Reversible Contraceptive data has been cleared.';

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
  String get settingsScreen_exportReversibleContraceptivesData =>
      'Export Reversible Contraceptives Data';

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
  String get settingsScreen_importReversibleContraceptivesData =>
      'Import Reversible Contraceptives Data';

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
  String get settingsScreen_importReversibleContraceptiveData_question =>
      'Are you sure you want to import Reversible Contraceptive Data?';

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
  String get settingsScreen_importReversibleContraceptiveDataDescription =>
      'Importing data will permanently overwrite all your existing reversible contraceptive history. This cannot be undone.';

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
    return 'Importování se nepodařilo: $message. Prosím ujistěte se, že je soubor uložen lokálně a zkuste to znovu.';
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
  String get settingsScreen_userProfile => 'Vy';

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
      'Zobrazit kartu o sexuální aktivitě na hlavní navigační liště.';

  @override
  String get preferencesScreen_StartingDayOfWeek => 'Počáteční den v týdnu';

  @override
  String get settingsScreen_about => 'O aplikaci';

  @override
  String get aboutScreen_version => 'Verze';

  @override
  String get aboutScreen_github => 'GitHub';

  @override
  String get aboutScreen_githubSubtitle => 'Zdrojový kód a sledování problémů';

  @override
  String get aboutScreen_discord => 'Discord';

  @override
  String get aboutScreen_discordSubtitle => 'Podpora a komunita';

  @override
  String get aboutScreen_share => 'Sdílet';

  @override
  String get aboutScreen_shareSubtitle => 'Sdílet aplikaci s přáteli';

  @override
  String get aboutScreen_urlError => 'Nebylo možné otevřít odkaz.';

  @override
  String get logSummaryWidget_loggedDays => 'Zaznamenané dny';

  @override
  String get logSummaryWidget_trackingHistory => 'Historie sledování';

  @override
  String get cycleLengthVarianceWidget_logAtLeastTwoPeriods =>
      'Je potřeba mít nejméně dva cykly pro zobrazení rozdílů.';

  @override
  String get cycleLengthVarianceWidget_title => 'Kolísání délky cyklu';

  @override
  String get cycleLengthVarianceWidget_averageCycle => 'Průměrný cyklus';

  @override
  String get cycleLengthVarianceWidget_cycle => 'Cyklus';

  @override
  String get periodDurationWidget_logAtLeastTwoPeriods =>
      'Zaznamenejte nejméně dvě menstruace pro zobrazení statistik.';

  @override
  String get periodDurationWidget_title => 'Kolísání délky menstruace';

  @override
  String get periodDurationWidget_averagePeriod => 'Průměrná menstruace';

  @override
  String get periodDurationWidget_period => 'Menstruace';

  @override
  String get flowIntensityWidget_flowIntensityBreakdown =>
      'Rozložení intenzity krvácení';

  @override
  String get flowIntensityWidget_noFlowDataLoggedYet =>
      'Dosud nebyly zaznamenány žádné údaje o krvácení.';

  @override
  String get painLevelWidget_noPainDataLoggedYet =>
      'Dosud nebyly zaznamenány žádné údaje o bolesti.';

  @override
  String get painLevelWidget_painLevelBreakdown => 'Rozdělení úrovní bolesti';

  @override
  String get monthlyFlowChartWidget_noDataToDisplay =>
      'Žádná data k zobrazení.';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatterns => 'Vzorce průběhu cyklu';

  @override
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription =>
      'Každá linka reprezentuje jeden kompletní cyklus';

  @override
  String get symptomFrequencyWidget_noSymptomsLoggedYet =>
      'Žádné příznaky nebyly zaznamenány.';

  @override
  String get symptomFrequencyWidget_mostCommonSymptoms =>
      'Nejvíce běžné příznaky';

  @override
  String get journalViewWidget_logYourFirstPeriod =>
      'Zaznamenejte první menstruaci.';

  @override
  String get listViewWidget_noPeriodsLogged =>
      'Žádné menstruace nebyly zaznamenány.\nKlepněte na tlačítko + pro přidání.';

  @override
  String get listViewWidget_confirmDelete => 'Potvrdit smazání';

  @override
  String get listViewWidget_confirmDeleteDescription =>
      'Jste si jisti že chcete smazat tento záznam?';

  @override
  String get emptyPillStateWidget_noPillRegimenFound =>
      'Žádný režim pilulek nebyl nalezen.';

  @override
  String get emptyPillStateWidget_noPillRegimenFoundDescription =>
      'Nastavte si balíček pilulek v nastavení, abyste mohli začít sledovat.';

  @override
  String pillStatus_pillsOfTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'z $count pilulek',
      one: 'z 1 pilulky',
    );
    return '$_temp0';
  }

  @override
  String get pillStatus_undo => 'Zpět';

  @override
  String get pillStatus_skip => 'Přeskočit';

  @override
  String get pillStatus_markAsTaken => 'Označit jako užité';

  @override
  String pillStatus_packStartInFuture(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Váš další balíček pilulek začne v $dateString.';
  }

  @override
  String get regimenSetupWidget_setUpPillRegimen => 'Nastavte si režim pilulek';

  @override
  String get regimenSetupWidget_packName => 'Název balíčku';

  @override
  String get regimenSetupWidget_pleaseEnterAName => 'Prosím zadejte jméno';

  @override
  String get regimenSetupWidget_activePills => 'Aktivní pilulky';

  @override
  String get regimenSetupWidget_enterANumber => 'Zadejte číslo';

  @override
  String get regimenSetupWidget_placeboPills => 'Placebo pilulky';

  @override
  String get regimenSetupWidget_firstDayOfThisPack =>
      'První den tohohle balíčku';

  @override
  String get symptomEntrySheet_logYourDay => 'Zaznamenejte svůj den';

  @override
  String get symptomEntrySheet_symptomsOptional => 'Příznaky (volitelné)';

  @override
  String get periodDetailsSheet_symptoms => 'Příznaky';

  @override
  String get periodDetailsSheet_flow => 'Tok';

  @override
  String
  get reversibleContraceptiveEntrySheet_logReversibleContraceptiveDetails =>
      'Log Reversible Contraceptive Details';

  @override
  String get sanitaryEntrySheet_logSanitaryProduct =>
      'Zaznamenat menstruační pomůcky';

  @override
  String get sanitaryEntrySheet_setReminderDuration =>
      'Nastavit délku připomenutí';

  @override
  String sanitaryEntrySheet_maxDuration(int hours) {
    return 'Maximální délka: $hours hodin';
  }

  @override
  String get sanitaryEntrySheet_futureLogTimeError =>
      'Zaznamenaný čas nemůže být v budoucnosti.';

  @override
  String get sanitaryEntrySheet_pastReminderTimeError =>
      'Čas ukončení připomenutí nemůže být v minulosti.';

  @override
  String periodPredictionCircle_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dní',
      one: 'Den',
    );
    return '$_temp0';
  }

  @override
  String get customSymptomDialog_newSymptom => 'Nový příznak';

  @override
  String get customSymptomDialog_enterCustomSymptom =>
      'Zadejte vlastní příznak';

  @override
  String get customSymptomDialog_temporarySymptom => 'Dočasný příznak';
}
