import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Menstrudel'**
  String get appTitle;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// A message that displays a count of days, handling singular and plural forms.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Day} other{{count} Days}}'**
  String dayCount(int count);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @flow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get flow;

  /// No description provided for @navBar_insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navBar_insights;

  /// No description provided for @navBar_logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get navBar_logs;

  /// No description provided for @navBar_pill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get navBar_pill;

  /// No description provided for @navBar_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navBar_settings;

  /// No description provided for @flowIntensity_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get flowIntensity_light;

  /// No description provided for @flowIntensity_moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get flowIntensity_moderate;

  /// No description provided for @flowIntensity_heavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get flowIntensity_heavy;

  /// No description provided for @symptom_headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get symptom_headache;

  /// No description provided for @symptom_fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get symptom_fatigue;

  /// No description provided for @symptom_cramps.
  ///
  /// In en, this message translates to:
  /// **'Cramps'**
  String get symptom_cramps;

  /// No description provided for @symptom_nausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get symptom_nausea;

  /// No description provided for @symptom_moodSwings.
  ///
  /// In en, this message translates to:
  /// **'Mood Swings'**
  String get symptom_moodSwings;

  /// No description provided for @symptom_bloating.
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get symptom_bloating;

  /// No description provided for @symptom_acne.
  ///
  /// In en, this message translates to:
  /// **'Acne'**
  String get symptom_acne;

  /// Title for the upcoming period notification.
  ///
  /// In en, this message translates to:
  /// **'Period Approaching'**
  String get notification_periodTitle;

  /// Body for the upcoming period notification.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your next period is estimated to start in 1 day.} other{Your next period is estimated to start in {count} days.}}'**
  String notification_periodBody(int count);

  /// Title for the daily pill reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Pill Reminder'**
  String get notification_pillTitle;

  /// Body for the daily pill reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to take your pill for today.'**
  String get notification_pillBody;

  /// Title for the tampon reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Tampon Reminder'**
  String get notification_tamponReminderTitle;

  /// Body for the tampon reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Remember to change your tampon.'**
  String get notification_tamponReminderBody;

  /// No description provided for @mainScreen_insightsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Insights'**
  String get mainScreen_insightsPageTitle;

  /// No description provided for @mainScreen_pillsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Pills'**
  String get mainScreen_pillsPageTitle;

  /// No description provided for @mainScreen_settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainScreen_settingsPageTitle;

  /// No description provided for @mainScreen_tooltipSetReminder.
  ///
  /// In en, this message translates to:
  /// **'Tampon reminder'**
  String get mainScreen_tooltipSetReminder;

  /// No description provided for @mainScreen_tooltipCancelReminder.
  ///
  /// In en, this message translates to:
  /// **'Cancel reminder'**
  String get mainScreen_tooltipCancelReminder;

  /// No description provided for @mainScreen_tooltipLogPeriod.
  ///
  /// In en, this message translates to:
  /// **'Log period'**
  String get mainScreen_tooltipLogPeriod;

  /// No description provided for @insightsScreen_errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get insightsScreen_errorPrefix;

  /// No description provided for @insightsScreen_noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get insightsScreen_noDataAvailable;

  /// No description provided for @logsScreen_calculatingPrediction.
  ///
  /// In en, this message translates to:
  /// **'Calculating prediction...'**
  String get logsScreen_calculatingPrediction;

  /// No description provided for @logScreen_logAtLeastTwoPeriods.
  ///
  /// In en, this message translates to:
  /// **'Log at least two periods to estimate next cycle.'**
  String get logScreen_logAtLeastTwoPeriods;

  /// No description provided for @logScreen_nextPeriodEstimate.
  ///
  /// In en, this message translates to:
  /// **'Next period Est'**
  String get logScreen_nextPeriodEstimate;

  /// No description provided for @logScreen_periodDueToday.
  ///
  /// In en, this message translates to:
  /// **'Period due today'**
  String get logScreen_periodDueToday;

  /// A label showing the total number of days period is overdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Period overdue by 1 day} other{Period overdue by {count} days}}'**
  String logScreen_periodOverdueBy(int count);

  /// No description provided for @logScreen_tamponReminderSetFor.
  ///
  /// In en, this message translates to:
  /// **'Tampon reminder set for'**
  String get logScreen_tamponReminderSetFor;

  /// No description provided for @logScreen_tamponReminderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Tampon reminder cancelled.'**
  String get logScreen_tamponReminderCancelled;

  /// No description provided for @logScreen_couldNotCancelReminder.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel reminder'**
  String get logScreen_couldNotCancelReminder;

  /// No description provided for @pillScreen_pillForTodayMarkedAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Pill for today marked as taken!'**
  String get pillScreen_pillForTodayMarkedAsTaken;

  /// No description provided for @settingsScreen_selectHistoryView.
  ///
  /// In en, this message translates to:
  /// **'Select History View'**
  String get settingsScreen_selectHistoryView;

  /// No description provided for @settingsScreen_deleteRegimen_question.
  ///
  /// In en, this message translates to:
  /// **'Delete Regimen?'**
  String get settingsScreen_deleteRegimen_question;

  /// No description provided for @settingsScreen_deleteRegimenDescription.
  ///
  /// In en, this message translates to:
  /// **'This will delete your current pill pack settings and all associated pill logs. This cannot be undone.'**
  String get settingsScreen_deleteRegimenDescription;

  /// No description provided for @settingsScreen_allLogsHaveBeenCleared.
  ///
  /// In en, this message translates to:
  /// **'All logs have been cleared.'**
  String get settingsScreen_allLogsHaveBeenCleared;

  /// No description provided for @settingsScreen_clearAllLogs_question.
  ///
  /// In en, this message translates to:
  /// **'Clear All Logs?'**
  String get settingsScreen_clearAllLogs_question;

  /// No description provided for @settingsScreen_deleteAllLogsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your period logs. Your app settings will not be affected.'**
  String get settingsScreen_deleteAllLogsDescription;

  /// No description provided for @settingsScreen_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsScreen_appearance;

  /// No description provided for @settingsScreen_historyViewStyle.
  ///
  /// In en, this message translates to:
  /// **'History View Style'**
  String get settingsScreen_historyViewStyle;

  /// No description provided for @settingsScreen_themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get settingsScreen_themeColor;

  /// No description provided for @settingsScreen_pickAColor.
  ///
  /// In en, this message translates to:
  /// **'Pick a Color'**
  String get settingsScreen_pickAColor;

  /// No description provided for @settingsScreen_view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get settingsScreen_view;

  /// No description provided for @settingsScreen_birthControl.
  ///
  /// In en, this message translates to:
  /// **'Birth Control'**
  String get settingsScreen_birthControl;

  /// No description provided for @settingsScreen_setUpPillRegimen.
  ///
  /// In en, this message translates to:
  /// **'Set Up Pill Regimen'**
  String get settingsScreen_setUpPillRegimen;

  /// No description provided for @settingsScreen_trackYourDailyPillIntake.
  ///
  /// In en, this message translates to:
  /// **'Track Your Daily Pill Intake'**
  String get settingsScreen_trackYourDailyPillIntake;

  /// No description provided for @settingsScreen_dailyPillReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Pill Reminder'**
  String get settingsScreen_dailyPillReminder;

  /// No description provided for @settingsScreen_reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get settingsScreen_reminderTime;

  /// No description provided for @settingsScreen_periodPredictionAndReminders.
  ///
  /// In en, this message translates to:
  /// **'Period Prediction & Reminders'**
  String get settingsScreen_periodPredictionAndReminders;

  /// No description provided for @settingsScreen_upcomingPeriodReminder.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Period Reminder'**
  String get settingsScreen_upcomingPeriodReminder;

  /// No description provided for @settingsScreen_remindMeBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind Me Before'**
  String get settingsScreen_remindMeBefore;

  /// No description provided for @settingsScreen_notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get settingsScreen_notificationTime;

  /// No description provided for @settingsScreen_clearAllLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear All Logs'**
  String get settingsScreen_clearAllLogs;

  /// No description provided for @tamponReminderDialog_tamponReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Tampon Reminder'**
  String get tamponReminderDialog_tamponReminderTitle;

  /// No description provided for @cycleLengthVarianceWidget_LogAtLeastTwoPeriods.
  ///
  /// In en, this message translates to:
  /// **'Need at least two cycles to show variance.'**
  String get cycleLengthVarianceWidget_LogAtLeastTwoPeriods;

  /// No description provided for @cycleLengthVarianceWidget_cycleAndPeriodVeriance.
  ///
  /// In en, this message translates to:
  /// **'Cycle & Period Variance'**
  String get cycleLengthVarianceWidget_cycleAndPeriodVeriance;

  /// No description provided for @cycleLengthVarianceWidget_averageCycle.
  ///
  /// In en, this message translates to:
  /// **'Average Cycle'**
  String get cycleLengthVarianceWidget_averageCycle;

  /// No description provided for @cycleLengthVarianceWidget_averagePeriod.
  ///
  /// In en, this message translates to:
  /// **'Average Period'**
  String get cycleLengthVarianceWidget_averagePeriod;

  /// No description provided for @cycleLengthVarianceWidget_period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get cycleLengthVarianceWidget_period;

  /// No description provided for @cycleLengthVarianceWidget_cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycleLengthVarianceWidget_cycle;

  /// No description provided for @flowIntensityWidget_flowIntensityBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Flow Intensity Breakdown'**
  String get flowIntensityWidget_flowIntensityBreakdown;

  /// No description provided for @flowIntensityWidget_noFlowDataLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No flow data logged yet.'**
  String get flowIntensityWidget_noFlowDataLoggedYet;

  /// No description provided for @monthlyFlowChartWidget_noDataToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No data to display.'**
  String get monthlyFlowChartWidget_noDataToDisplay;

  /// No description provided for @monthlyFlowChartWidget_cycleFlowPatterns.
  ///
  /// In en, this message translates to:
  /// **'Cycle Flow Patterns'**
  String get monthlyFlowChartWidget_cycleFlowPatterns;

  /// No description provided for @monthlyFlowChartWidget_cycleFlowPatternsDescription.
  ///
  /// In en, this message translates to:
  /// **'Each line represents one complete cycle'**
  String get monthlyFlowChartWidget_cycleFlowPatternsDescription;

  /// No description provided for @symptomFrequencyWidget_noSymptomsLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No symptoms logged yet.'**
  String get symptomFrequencyWidget_noSymptomsLoggedYet;

  /// No description provided for @symptomFrequencyWidget_mostCommonSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Most Common Symptoms'**
  String get symptomFrequencyWidget_mostCommonSymptoms;

  /// No description provided for @yearHeatMapWidget_yearlyOverview.
  ///
  /// In en, this message translates to:
  /// **'Yearly Overview'**
  String get yearHeatMapWidget_yearlyOverview;

  /// No description provided for @journalViewWidget_logYourFirstPeriod.
  ///
  /// In en, this message translates to:
  /// **'Log your first period.'**
  String get journalViewWidget_logYourFirstPeriod;

  /// No description provided for @listViewWidget_noPeriodsLogged.
  ///
  /// In en, this message translates to:
  /// **'No periods logged yet.\nTap the + button to add one.'**
  String get listViewWidget_noPeriodsLogged;

  /// No description provided for @listViewWidget_confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get listViewWidget_confirmDelete;

  /// No description provided for @listViewWidget_confirmDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry?'**
  String get listViewWidget_confirmDeleteDescription;

  /// No description provided for @emptyPillStateWidget_noPillRegimenFound.
  ///
  /// In en, this message translates to:
  /// **'No pill regimen found.'**
  String get emptyPillStateWidget_noPillRegimenFound;

  /// No description provided for @emptyPillStateWidget_noPillRegimenFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Set up your pill pack in settings to start tracking.'**
  String get emptyPillStateWidget_noPillRegimenFoundDescription;

  /// No description provided for @pillPackVisualiser_yourPack.
  ///
  /// In en, this message translates to:
  /// **'Your Pack'**
  String get pillPackVisualiser_yourPack;

  /// A label showing the total number of pills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{of 1 pill} other{of {count} pills}}'**
  String pillStatus_pillsOfTotal(int count);

  /// No description provided for @pillStatus_allSet.
  ///
  /// In en, this message translates to:
  /// **'All Set!'**
  String get pillStatus_allSet;

  /// No description provided for @pillStatus_markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark As Taken'**
  String get pillStatus_markAsTaken;

  /// No description provided for @regimenSetupWidget_setUpPillRegimen.
  ///
  /// In en, this message translates to:
  /// **'Set Up Pill Regimen'**
  String get regimenSetupWidget_setUpPillRegimen;

  /// No description provided for @regimenSetupWidget_packName.
  ///
  /// In en, this message translates to:
  /// **'Pack Name'**
  String get regimenSetupWidget_packName;

  /// No description provided for @regimenSetupWidget_pleaseEnterAName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get regimenSetupWidget_pleaseEnterAName;

  /// No description provided for @regimenSetupWidget_activePills.
  ///
  /// In en, this message translates to:
  /// **'Active Pills'**
  String get regimenSetupWidget_activePills;

  /// No description provided for @regimenSetupWidget_enterANumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get regimenSetupWidget_enterANumber;

  /// No description provided for @regimenSetupWidget_placeboPills.
  ///
  /// In en, this message translates to:
  /// **'Placebo Pills'**
  String get regimenSetupWidget_placeboPills;

  /// No description provided for @regimenSetupWidget_firstDayOfThisPack.
  ///
  /// In en, this message translates to:
  /// **'First Day of This Pack'**
  String get regimenSetupWidget_firstDayOfThisPack;

  /// No description provided for @symptomEntrySheet_logYourDay.
  ///
  /// In en, this message translates to:
  /// **'Log Your Day'**
  String get symptomEntrySheet_logYourDay;

  /// No description provided for @symptomEntrySheet_symptomsOptional.
  ///
  /// In en, this message translates to:
  /// **'Symptoms (Optional)'**
  String get symptomEntrySheet_symptomsOptional;

  /// No description provided for @periodDetailsSheet_symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get periodDetailsSheet_symptoms;

  /// No description provided for @periodDetailsSheet_flow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get periodDetailsSheet_flow;

  /// A label showing the total number of days until period is due.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Day} other{Days}}'**
  String periodPredictionCircle_days(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
