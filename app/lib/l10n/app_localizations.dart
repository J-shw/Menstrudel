import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Menstrudel'**
  String get appTitle;

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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

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

  /// No description provided for @logScreen_periodOverdueBy.
  ///
  /// In en, this message translates to:
  /// **'Period overdue by'**
  String get logScreen_periodOverdueBy;

  /// No description provided for @logScreen_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get logScreen_days;

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

  /// No description provided for @settingsScreen_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get settingsScreen_day;

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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
