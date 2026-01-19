import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

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
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Menstrudel'**
  String get appTitle;

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next Due'**
  String get nextDue;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @shortest.
  ///
  /// In en, this message translates to:
  /// **'Shortest'**
  String get shortest;

  /// No description provided for @longest.
  ///
  /// In en, this message translates to:
  /// **'Longest'**
  String get longest;

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

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

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

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// A message that displays a count of days, handling singular and plural forms.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Day} other{{count} Days}}'**
  String dayCount(int count);

  /// A message that displays a count of months, handling singular and plural forms.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Month} other{{count} Months}}'**
  String monthCount(int count);

  /// A message that displays a count of years, handling singular and plural forms.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} Year} other{{count} Years}}'**
  String yearCount(int count);

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

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

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

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

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removed;

  /// No description provided for @totalLogs.
  ///
  /// In en, this message translates to:
  /// **'Total Logs'**
  String get totalLogs;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @flow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get flow;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

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

  /// No description provided for @navBar_sanitary.
  ///
  /// In en, this message translates to:
  /// **'Sanitary'**
  String get navBar_sanitary;

  /// No description provided for @navBar_sexActivity.
  ///
  /// In en, this message translates to:
  /// **'Sex Activity'**
  String get navBar_sexActivity;

  /// No description provided for @navBar_pill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get navBar_pill;

  /// No description provided for @navBar_larc.
  ///
  /// In en, this message translates to:
  /// **'LARC'**
  String get navBar_larc;

  /// No description provided for @navBar_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navBar_settings;

  /// No description provided for @flowIntensity_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get flowIntensity_none;

  /// No description provided for @flowIntensity_spotting.
  ///
  /// In en, this message translates to:
  /// **'Spotting'**
  String get flowIntensity_spotting;

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

  /// No description provided for @builtInSymptom_acne.
  ///
  /// In en, this message translates to:
  /// **'Acne'**
  String get builtInSymptom_acne;

  /// No description provided for @builtInSymptom_backPain.
  ///
  /// In en, this message translates to:
  /// **'Back pain'**
  String get builtInSymptom_backPain;

  /// No description provided for @builtInSymptom_bloating.
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get builtInSymptom_bloating;

  /// No description provided for @builtInSymptom_cramps.
  ///
  /// In en, this message translates to:
  /// **'Cramps'**
  String get builtInSymptom_cramps;

  /// No description provided for @builtInSymptom_fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get builtInSymptom_fatigue;

  /// No description provided for @builtInSymptom_headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get builtInSymptom_headache;

  /// No description provided for @builtInSymptom_moodSwings.
  ///
  /// In en, this message translates to:
  /// **'Mood swings'**
  String get builtInSymptom_moodSwings;

  /// No description provided for @builtInSymptom_nausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get builtInSymptom_nausea;

  /// No description provided for @painLevel_title.
  ///
  /// In en, this message translates to:
  /// **'Pain Level'**
  String get painLevel_title;

  /// No description provided for @painLevel_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get painLevel_none;

  /// No description provided for @painLevel_mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get painLevel_mild;

  /// No description provided for @painLevel_moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get painLevel_moderate;

  /// No description provided for @painLevel_severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get painLevel_severe;

  /// No description provided for @pain_unbearable.
  ///
  /// In en, this message translates to:
  /// **'Unbearable'**
  String get pain_unbearable;

  /// No description provided for @larcType_iud.
  ///
  /// In en, this message translates to:
  /// **'IUD'**
  String get larcType_iud;

  /// No description provided for @larcType_implant.
  ///
  /// In en, this message translates to:
  /// **'Implant'**
  String get larcType_implant;

  /// No description provided for @larcType_injection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get larcType_injection;

  /// No description provided for @larcType_ring.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get larcType_ring;

  /// No description provided for @larcType_patch.
  ///
  /// In en, this message translates to:
  /// **'Patch'**
  String get larcType_patch;

  /// No description provided for @sanitaryProduct_tampon.
  ///
  /// In en, this message translates to:
  /// **'Tampon'**
  String get sanitaryProduct_tampon;

  /// No description provided for @sanitaryProduct_pad.
  ///
  /// In en, this message translates to:
  /// **'Pad'**
  String get sanitaryProduct_pad;

  /// No description provided for @sanitaryProduct_menstrualCup.
  ///
  /// In en, this message translates to:
  /// **'Menstrual Cup'**
  String get sanitaryProduct_menstrualCup;

  /// No description provided for @sanitaryProduct_periodUnderwear.
  ///
  /// In en, this message translates to:
  /// **'Period Underwear'**
  String get sanitaryProduct_periodUnderwear;

  /// No description provided for @sanitaryProducts_mostUsed.
  ///
  /// In en, this message translates to:
  /// **'Most Used'**
  String get sanitaryProducts_mostUsed;

  /// No description provided for @sanitaryProducts_usageTrend.
  ///
  /// In en, this message translates to:
  /// **'Usage Trend'**
  String get sanitaryProducts_usageTrend;

  /// No description provided for @sexProtection_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get sexProtection_none;

  /// No description provided for @sexProtection_barrier.
  ///
  /// In en, this message translates to:
  /// **'Barrier'**
  String get sexProtection_barrier;

  /// No description provided for @sexProtection_hormonal.
  ///
  /// In en, this message translates to:
  /// **'Hormonal'**
  String get sexProtection_hormonal;

  /// No description provided for @sexProtection_natural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get sexProtection_natural;

  /// No description provided for @sexProtection_permanent.
  ///
  /// In en, this message translates to:
  /// **'Permanent'**
  String get sexProtection_permanent;

  /// No description provided for @sexType_vaginal.
  ///
  /// In en, this message translates to:
  /// **'Vaginal'**
  String get sexType_vaginal;

  /// No description provided for @sexType_anal.
  ///
  /// In en, this message translates to:
  /// **'Anal'**
  String get sexType_anal;

  /// No description provided for @sexType_oral.
  ///
  /// In en, this message translates to:
  /// **'Oral'**
  String get sexType_oral;

  /// No description provided for @sexType_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get sexType_manual;

  /// No description provided for @sexParticipation_solo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get sexParticipation_solo;

  /// No description provided for @sexParticipation_partner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get sexParticipation_partner;

  /// No description provided for @sexParticipation_group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get sexParticipation_group;

  /// For users tracking periods for general health.
  ///
  /// In en, this message translates to:
  /// **'General Health'**
  String get userGoal_general;

  /// For users focusing on sexual health.
  ///
  /// In en, this message translates to:
  /// **'Sexual Health'**
  String get userGoal_sexual;

  /// For users focusing on trying to conceive.
  ///
  /// In en, this message translates to:
  /// **'Trying to Conceive'**
  String get userGoal_conceive;

  /// For users focusing on avoiding pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Avoiding Pregnancy'**
  String get userGoal_avoid;

  /// No description provided for @dayOfWeek_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayOfWeek_monday;

  /// No description provided for @dayOfWeek_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayOfWeek_tuesday;

  /// No description provided for @dayOfWeek_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayOfWeek_wednesday;

  /// No description provided for @dayOfWeek_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayOfWeek_thursday;

  /// No description provided for @dayOfWeek_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayOfWeek_friday;

  /// No description provided for @dayOfWeek_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get dayOfWeek_saturday;

  /// No description provided for @dayOfWeek_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get dayOfWeek_sunday;

  /// No description provided for @error_valueMustbePositive.
  ///
  /// In en, this message translates to:
  /// **'Value must be positive'**
  String get error_valueMustbePositive;

  /// No description provided for @error_valueCannotBeNull.
  ///
  /// In en, this message translates to:
  /// **'Value cannot be null'**
  String get error_valueCannotBeNull;

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

  /// Title for the overdue period notification.
  ///
  /// In en, this message translates to:
  /// **'Period Overdue'**
  String get notification_periodOverdueTitle;

  /// Body for the overdue period notification.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your next period is overdue by 1 day.} other{Your next period is overdue by {count} days.}}'**
  String notification_periodOverdueBody(int count);

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

  /// Title for the LARC reminder notification.
  ///
  /// In en, this message translates to:
  /// **'LARC Reminder'**
  String get notification_larcTitle;

  /// The body of the LARC reminder notification, indicating the type of LARC and how many days until renewal.
  ///
  /// In en, this message translates to:
  /// **'{type} is due for renewal in {days} days.'**
  String notification_larcBody(String type, int days);

  /// Title for the logging reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Logging Reminder'**
  String get notification_loggingReminderTitle;

  /// Body for the logging reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Tap to log your flow for today.'**
  String get notification_loggingReminderBody;

  /// No description provided for @notification_SanitaryProductReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Sanitary Product Reminder'**
  String get notification_SanitaryProductReminderTitle;

  /// No description provided for @notification_SanitaryProductReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Remember to change your product.'**
  String get notification_SanitaryProductReminderBody;

  /// Title for the onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Menstrudel'**
  String get onboardingScreen_welcomeToMenstrudel;

  /// Small into description for the onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'Your offline, private cycle tracker.'**
  String get onboardingScreen_welcomeToMenstrudelDescription;

  /// Title for the profile onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'About You'**
  String get onboardingScreen_profileTitle;

  /// Name question for the profile onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingScreen_profileName;

  /// Birth date for the profile onboarding screen. This field is optional.
  ///
  /// In en, this message translates to:
  /// **'Birth Date (Optional)'**
  String get onboardingScreen_profileDate;

  /// Displays when birthday value is none (Due to being optional). Prompts user to set their birthday
  ///
  /// In en, this message translates to:
  /// **'Tap to set birthday'**
  String get onboardingScreen_profileDatePlaceholder;

  /// Title for the goal onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get onboardingScreen_goalTitle;

  /// Description for the goal onboarding screen.
  ///
  /// In en, this message translates to:
  /// **'This helps tailor the insights you see.'**
  String get onboardingScreen_goalDescription;

  /// Hint for birth control settings
  ///
  /// In en, this message translates to:
  /// **'Note: You can enable Pill or LARC tracking later in the app settings under \'{sectionName}\' if wanted.'**
  String onboardingScreen_contraceptionHint(String sectionName);

  /// Button text for the get started navigation button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingScreen_getStarted;

  /// Used for the main logs screen fab button as a tooltip.
  ///
  /// In en, this message translates to:
  /// **'Log day'**
  String get fabToolTip_logs;

  /// Used for the sanitary screen fab button as a tooltip.
  ///
  /// In en, this message translates to:
  /// **'Log sanitary product'**
  String get fabToolTip_sanitary;

  /// Used for the sex activity screen fab button as a tooltip.
  ///
  /// In en, this message translates to:
  /// **'Log sex activity'**
  String get fabToolTip_sexActivity;

  /// Used for the LARC screen fab button as a tooltip.
  ///
  /// In en, this message translates to:
  /// **'Log LARC'**
  String get fabToolTip_larc;

  /// No description provided for @mainScreen_logsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get mainScreen_logsPageTitle;

  /// No description provided for @mainSceen_sexActivityPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Sex Activity'**
  String get mainSceen_sexActivityPageTitle;

  /// No description provided for @mainScreen_sanitaryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Sanitary Products'**
  String get mainScreen_sanitaryPageTitle;

  /// No description provided for @mainScreen_pillsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Pills'**
  String get mainScreen_pillsPageTitle;

  /// No description provided for @mainScreen_LarcsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'LARCs'**
  String get mainScreen_LarcsPageTitle;

  /// No description provided for @mainScreen_settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainScreen_settingsPageTitle;

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

  /// No description provided for @pillScreen_pillForTodayMarkedAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Pill for today marked as taken.'**
  String get pillScreen_pillForTodayMarkedAsTaken;

  /// No description provided for @pillScreen_pillForTodayMarkedAsSkipped.
  ///
  /// In en, this message translates to:
  /// **'Pill for today marked as skipped.'**
  String get pillScreen_pillForTodayMarkedAsSkipped;

  /// No description provided for @larcScreen_noLarcRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No LARC records found.'**
  String get larcScreen_noLarcRecordsFound;

  /// The total LARC history count.
  ///
  /// In en, this message translates to:
  /// **'History ({history})'**
  String larcScreen_history(int history);

  /// The total active LARC count.
  ///
  /// In en, this message translates to:
  /// **'Active LARCs ({activeCount})'**
  String larcScreen_activeLarcs(int activeCount);

  /// No description provided for @larcScreen_activeLarcsDescription.
  ///
  /// In en, this message translates to:
  /// **'Currently monitored LARC entries.'**
  String get larcScreen_activeLarcsDescription;

  /// No description provided for @larcScreen_noActiveRecords.
  ///
  /// In en, this message translates to:
  /// **'No LARC is currently active. Please log a new entry.'**
  String get larcScreen_noActiveRecords;

  /// No description provided for @larcScreen_noHistoryRecords.
  ///
  /// In en, this message translates to:
  /// **'No past or overdue LARC records found.'**
  String get larcScreen_noHistoryRecords;

  /// No description provided for @sanitaryProductsScreen_noSanitaryProductRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No sanitary product records found.'**
  String get sanitaryProductsScreen_noSanitaryProductRecordsFound;

  /// The total sanitary product history count.
  ///
  /// In en, this message translates to:
  /// **'History ({history})'**
  String sanitaryProductsScreen_history(int history);

  /// No description provided for @sanitaryProductsScreen_noHistoryRecords.
  ///
  /// In en, this message translates to:
  /// **'No past sanitary product records found.'**
  String get sanitaryProductsScreen_noHistoryRecords;

  /// Label showing the type of active sanitary product.
  ///
  /// In en, this message translates to:
  /// **'Active {activeType}'**
  String sanitaryProductsScreen_activeProduct(String activeType);

  /// Label showing the time when the sanitary product needs to be changed.
  ///
  /// In en, this message translates to:
  /// **'Change Due At {time}'**
  String sanitaryProductsScreen_changeDueAt(String time);

  /// No description provided for @sexActivityScreen_noSexActivityRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No sex activity records found.'**
  String get sexActivityScreen_noSexActivityRecordsFound;

  /// The total sex activity history count.
  ///
  /// In en, this message translates to:
  /// **'History ({history})'**
  String sexActivityScreen_history(int history);

  /// Title for the profile settings button.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsScreen_profile;

  /// No description provided for @settingsScreen_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsScreen_name;

  /// No description provided for @settingsScreen_birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get settingsScreen_birthDate;

  /// Used when birth date is not set.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsScreen_notSet;

  /// No description provided for @settingsScreen_appGoal.
  ///
  /// In en, this message translates to:
  /// **'App Goal'**
  String get settingsScreen_appGoal;

  /// No description provided for @settingsScreen_profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get settingsScreen_profileUpdated;

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

  /// No description provided for @settingsScreen_appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get settingsScreen_appTheme;

  /// No description provided for @settingsScreen_themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsScreen_themeLight;

  /// No description provided for @settingsScreen_themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsScreen_themeDark;

  /// No description provided for @settingsScreen_themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsScreen_themeSystem;

  /// No description provided for @settingsScreen_dynamicTheme.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Theme'**
  String get settingsScreen_dynamicTheme;

  /// No description provided for @settingsScreen_useWallpaperColors.
  ///
  /// In en, this message translates to:
  /// **'Use Wallpaper Colors'**
  String get settingsScreen_useWallpaperColors;

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

  /// No description provided for @settingsScreen_enablePillTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable Pill Tracking'**
  String get settingsScreen_enablePillTracking;

  /// No description provided for @settingsScreen_pillDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your daily pill intake and get reminders.'**
  String get settingsScreen_pillDescription;

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

  /// No description provided for @settingsScreen_overduePeriodReminder.
  ///
  /// In en, this message translates to:
  /// **'Overdue Period Reminder'**
  String get settingsScreen_overduePeriodReminder;

  /// No description provided for @settingsScreen_remindMeAfter.
  ///
  /// In en, this message translates to:
  /// **'Remind Me After'**
  String get settingsScreen_remindMeAfter;

  /// No description provided for @settingsScreen_enableLarcTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable LARC Tracking'**
  String get settingsScreen_enableLarcTracking;

  /// No description provided for @settingsScreen_larcDescription.
  ///
  /// In en, this message translates to:
  /// **'Track long-acting reversible contraceptives (LARCs).'**
  String get settingsScreen_larcDescription;

  /// No description provided for @settingsScreen_larcType.
  ///
  /// In en, this message translates to:
  /// **'LARC Type'**
  String get settingsScreen_larcType;

  /// No description provided for @settingsScreen_setDuration.
  ///
  /// In en, this message translates to:
  /// **'Set Duration'**
  String get settingsScreen_setDuration;

  /// No description provided for @settingsScreen_larcDuration.
  ///
  /// In en, this message translates to:
  /// **'LARC Replacement Duration'**
  String get settingsScreen_larcDuration;

  /// No description provided for @settingsScreen_enableLARCReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable LARC Reminder'**
  String get settingsScreen_enableLARCReminder;

  /// No description provided for @settingsScreen_currentDuration.
  ///
  /// In en, this message translates to:
  /// **'Current Duration'**
  String get settingsScreen_currentDuration;

  /// No description provided for @settingsScreen_durationInDays.
  ///
  /// In en, this message translates to:
  /// **'Duration (Days)'**
  String get settingsScreen_durationInDays;

  /// No description provided for @settingsScreen_LoggingScreen.
  ///
  /// In en, this message translates to:
  /// **'Logging'**
  String get settingsScreen_LoggingScreen;

  /// No description provided for @settingsScreen_enableLoggingReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable Logging Reminders'**
  String get settingsScreen_enableLoggingReminders;

  /// No description provided for @settingsScreen_loggingReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'If you log a day with flow, you will receive a notification the following day to log your status.'**
  String get settingsScreen_loggingReminderDescription;

  /// No description provided for @settingsScreen_loggingReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Logging Reminder Time'**
  String get settingsScreen_loggingReminderTime;

  /// No description provided for @settingsScreen_defaultSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Default Symptoms'**
  String get settingsScreen_defaultSymptoms;

  /// No description provided for @settingsScreen_defaultSymptomsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These are always available when logging new periods.\nTap an existing symptom to delete or \'+\' to add a new one.'**
  String get settingsScreen_defaultSymptomsSubtitle;

  /// Question whether a symptom should be deleted.
  ///
  /// In en, this message translates to:
  /// **'Delete \'{symptom}\'?'**
  String settingsScreen_deleteDefaultSymptomQuestion(String symptom);

  /// No description provided for @settingsScreen_resetSymptomsList.
  ///
  /// In en, this message translates to:
  /// **'Reset Symptoms List?'**
  String get settingsScreen_resetSymptomsList;

  /// No description provided for @settingsScreen_resetSymptomsListDescription.
  ///
  /// In en, this message translates to:
  /// **'This will remove all your custom symptoms and restore the original built-in list.\n\nYour existing log entries will not be changed.'**
  String get settingsScreen_resetSymptomsListDescription;

  /// Question whether a symptom should be deleted.
  ///
  /// In en, this message translates to:
  /// **'\'{symptom}\' will no longer be available when logging a period.\n\n{usageCount, plural, zero{There are currently no period logs with this symptom!} one{There is already 1 period log with this symptom!\nThis log will not be changed.} other{There are {usageCount} period logs with this symptom!\nThese logs will not be changed.}}'**
  String settingsScreen_deleteDefaultSymptomDescription(
    String symptom,
    num usageCount,
  );

  /// Header for the section listing all created pill regimens.
  ///
  /// In en, this message translates to:
  /// **'Pill Regimens'**
  String get settingsScreen_pillRegimens;

  /// Button to select a regimen and set it as the one currently being tracked.
  ///
  /// In en, this message translates to:
  /// **'Set as Active'**
  String get settingsScreen_makeActive;

  /// Header for the daily reminder settings section.
  ///
  /// In en, this message translates to:
  /// **'Active Regimen Reminder Settings'**
  String get settingsScreen_activeRegimenReminder;

  /// No description provided for @settingsScreen_pack.
  ///
  /// In en, this message translates to:
  /// **'Pack'**
  String get settingsScreen_pack;

  /// No description provided for @settingsScreen_dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsScreen_dataManagement;

  /// No description provided for @settingsScreen_dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settingsScreen_dangerZone;

  /// No description provided for @settingsScreen_clearAllLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear All Logs'**
  String get settingsScreen_clearAllLogs;

  /// No description provided for @settingsScreen_clearAllLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deletes your entire period and symptom history.'**
  String get settingsScreen_clearAllLogsSubtitle;

  /// No description provided for @settingsScreen_clearAllPillData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Pill Data'**
  String get settingsScreen_clearAllPillData;

  /// No description provided for @settingsScreen_clearAllPillDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes your pill regimen and intake history.'**
  String get settingsScreen_clearAllPillDataSubtitle;

  /// No description provided for @settingsScreen_clearAllPillData_question.
  ///
  /// In en, this message translates to:
  /// **'Clear All Pill Data?'**
  String get settingsScreen_clearAllPillData_question;

  /// No description provided for @settingsScreen_deleteAllPillDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your pill regimen, reminders, and intake history.'**
  String get settingsScreen_deleteAllPillDataDescription;

  /// No description provided for @settingsScreen_allPillDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All pill data has been cleared.'**
  String get settingsScreen_allPillDataCleared;

  /// No description provided for @settingsScreen_clearAllLarcData.
  ///
  /// In en, this message translates to:
  /// **'Clear All LARC Data'**
  String get settingsScreen_clearAllLarcData;

  /// No description provided for @settingsScreen_clearAllLarcDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes your LARCs history.'**
  String get settingsScreen_clearAllLarcDataSubtitle;

  /// No description provided for @settingsScreen_clearAllLarcData_question.
  ///
  /// In en, this message translates to:
  /// **'Clear All LARC Data?'**
  String get settingsScreen_clearAllLarcData_question;

  /// No description provided for @settingsScreen_deleteAllLarcDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your LARC history.'**
  String get settingsScreen_deleteAllLarcDataDescription;

  /// No description provided for @settingsScreen_allLarcDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All LARC data has been cleared.'**
  String get settingsScreen_allLarcDataCleared;

  /// No description provided for @settingsScreen_clearAllSanitaryData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Sanitary Products Data'**
  String get settingsScreen_clearAllSanitaryData;

  /// No description provided for @settingsScreen_clearAllSanitaryDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes your sanitary products history.'**
  String get settingsScreen_clearAllSanitaryDataSubtitle;

  /// No description provided for @settingsScreen_clearAllSanitaryData_question.
  ///
  /// In en, this message translates to:
  /// **'Clear All Sanitary Products Data?'**
  String get settingsScreen_clearAllSanitaryData_question;

  /// No description provided for @settingsScreen_deleteAllSanitaryDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your sanitary products history.'**
  String get settingsScreen_deleteAllSanitaryDataDescription;

  /// No description provided for @settingsScreen_allSanitaryDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All sanitary products data has been cleared.'**
  String get settingsScreen_allSanitaryDataCleared;

  /// No description provided for @settingsScreen_exportPeriodData.
  ///
  /// In en, this message translates to:
  /// **'Export Period Data'**
  String get settingsScreen_exportPeriodData;

  /// No description provided for @settingsScreen_exportPillData.
  ///
  /// In en, this message translates to:
  /// **'Export Pill Data'**
  String get settingsScreen_exportPillData;

  /// No description provided for @settingsScreen_exportLarcsData.
  ///
  /// In en, this message translates to:
  /// **'Export LARCs Data'**
  String get settingsScreen_exportLarcsData;

  /// No description provided for @settingsScreen_exportSanitaryData.
  ///
  /// In en, this message translates to:
  /// **'Export Sanitary Products Data'**
  String get settingsScreen_exportSanitaryData;

  /// No description provided for @settingsScreen_exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a JSON backup file.'**
  String get settingsScreen_exportDataSubtitle;

  /// No description provided for @settingsScreen_exportSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully.'**
  String get settingsScreen_exportSuccessful;

  /// No description provided for @settingsScreen_exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again.'**
  String get settingsScreen_exportFailed;

  /// No description provided for @settingsScreen_noDataToExport.
  ///
  /// In en, this message translates to:
  /// **'No data found to export.'**
  String get settingsScreen_noDataToExport;

  /// No description provided for @settingsScreen_exportDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Here is my MenstruDel data export.'**
  String get settingsScreen_exportDataMessage;

  /// No description provided for @settingsScreen_exportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsScreen_exportDataTitle;

  /// No description provided for @settingsScreen_importDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get settingsScreen_importDataTitle;

  /// No description provided for @settingsScreen_importPeriodData.
  ///
  /// In en, this message translates to:
  /// **'Import Period Data'**
  String get settingsScreen_importPeriodData;

  /// No description provided for @settingsScreen_importPillData.
  ///
  /// In en, this message translates to:
  /// **'Import Pill Data'**
  String get settingsScreen_importPillData;

  /// No description provided for @settingsScreen_importLarcsData.
  ///
  /// In en, this message translates to:
  /// **'Import LARCs Data'**
  String get settingsScreen_importLarcsData;

  /// No description provided for @settingsScreen_importSanitaryData.
  ///
  /// In en, this message translates to:
  /// **'Import Sanitary Products Data'**
  String get settingsScreen_importSanitaryData;

  /// No description provided for @settingsScreen_importDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Overwrites existing data.'**
  String get settingsScreen_importDataSubtitle;

  /// No description provided for @settingsScreen_importPeriodData_question.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to import Period Data?'**
  String get settingsScreen_importPeriodData_question;

  /// No description provided for @settingsScreen_importPillData_question.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to import Pill Data?'**
  String get settingsScreen_importPillData_question;

  /// No description provided for @settingsScreen_importLarcData_question.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to import LARC Data?'**
  String get settingsScreen_importLarcData_question;

  /// No description provided for @settingsScreen_importSanitaryData_question.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to import Sanitary Products Data?'**
  String get settingsScreen_importSanitaryData_question;

  /// No description provided for @settingsScreen_importPeriodDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Importing data will permanently overwrite all your existing period logs and period settings. This cannot be undone.'**
  String get settingsScreen_importPeriodDataDescription;

  /// No description provided for @settingsScreen_importPillDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Importing data will permanently overwrite all your existing pill history. This cannot be undone.'**
  String get settingsScreen_importPillDataDescription;

  /// No description provided for @settingsScreen_importLarcDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Importing data will permanently overwrite all your existing LARC history. This cannot be undone.'**
  String get settingsScreen_importLarcDataDescription;

  /// No description provided for @settingsScreen_importSanitaryDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Importing data will permanently overwrite all your existing sanitary product history. This cannot be undone.'**
  String get settingsScreen_importSanitaryDataDescription;

  /// No description provided for @settingsScreen_importSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully!'**
  String get settingsScreen_importSuccessful;

  /// No description provided for @settingsScreen_importFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to import data. Please try again.'**
  String get settingsScreen_importFailed;

  /// No description provided for @settingsScreen_importInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid file format or data structure.'**
  String get settingsScreen_importInvalidFile;

  /// General message when file import fails for unknown reasons.
  ///
  /// In en, this message translates to:
  /// **'Failed to import data. Please ensure the file is saved locally.'**
  String get settingsScreen_importErrorGeneral;

  /// Error when the native file picker fails, includes the specific error message.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {message}. Please ensure the file is saved on the device and try again.'**
  String settingsScreen_importErrorPlatform(String message);

  /// No description provided for @settingsScreen_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsScreen_security;

  /// No description provided for @securityScreen_enableBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Lock'**
  String get securityScreen_enableBiometricLock;

  /// No description provided for @securityScreen_enableBiometricLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require fingerprint or face ID to open the app.'**
  String get securityScreen_enableBiometricLockSubtitle;

  /// No description provided for @securityScreen_noBiometricsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No passcode, fingerprint, or face ID found. Please set one up in your device\'s settings.'**
  String get securityScreen_noBiometricsAvailable;

  /// Title for the user profile settings button.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get settingsScreen_userProfile;

  /// No description provided for @settingsScreen_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsScreen_preferences;

  /// No description provided for @preferencesScreen_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get preferencesScreen_language;

  /// No description provided for @preferencesScreen_enableSanitaryProductsScreen.
  ///
  /// In en, this message translates to:
  /// **'Enable Sanitary Products Screen'**
  String get preferencesScreen_enableSanitaryProductsScreen;

  /// No description provided for @preferencesScreen_enableSanitaryProductsScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show the Sanitary Products tab on the main navigation bar.'**
  String get preferencesScreen_enableSanitaryProductsScreenSubtitle;

  /// No description provided for @preferencesScreen_enableSexActivityScreen.
  ///
  /// In en, this message translates to:
  /// **'Enable Sex Activity Screen'**
  String get preferencesScreen_enableSexActivityScreen;

  /// No description provided for @preferencesScreen_enableSexActivityScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show the Sex Activity tab on the main navigation bar.'**
  String get preferencesScreen_enableSexActivityScreenSubtitle;

  /// No description provided for @preferencesScreen_StartingDayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Starting Day of the Week'**
  String get preferencesScreen_StartingDayOfWeek;

  /// No description provided for @settingsScreen_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsScreen_about;

  /// No description provided for @aboutScreen_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutScreen_version;

  /// No description provided for @aboutScreen_github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get aboutScreen_github;

  /// No description provided for @aboutScreen_githubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Source code and issue tracking'**
  String get aboutScreen_githubSubtitle;

  /// No description provided for @aboutScreen_discord.
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get aboutScreen_discord;

  /// No description provided for @aboutScreen_discordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support and community'**
  String get aboutScreen_discordSubtitle;

  /// No description provided for @aboutScreen_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get aboutScreen_share;

  /// No description provided for @aboutScreen_shareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share the app with friends'**
  String get aboutScreen_shareSubtitle;

  /// No description provided for @aboutScreen_urlError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get aboutScreen_urlError;

  /// No description provided for @logSummaryWidget_loggedDays.
  ///
  /// In en, this message translates to:
  /// **'Logged Days'**
  String get logSummaryWidget_loggedDays;

  /// No description provided for @logSummaryWidget_trackingHistory.
  ///
  /// In en, this message translates to:
  /// **'Tracking History'**
  String get logSummaryWidget_trackingHistory;

  /// No description provided for @cycleLengthVarianceWidget_logAtLeastTwoPeriods.
  ///
  /// In en, this message translates to:
  /// **'Need at least two cycles to show variance.'**
  String get cycleLengthVarianceWidget_logAtLeastTwoPeriods;

  /// No description provided for @cycleLengthVarianceWidget_title.
  ///
  /// In en, this message translates to:
  /// **'Cycle Length Variance'**
  String get cycleLengthVarianceWidget_title;

  /// No description provided for @cycleLengthVarianceWidget_averageCycle.
  ///
  /// In en, this message translates to:
  /// **'Avg. Cycle'**
  String get cycleLengthVarianceWidget_averageCycle;

  /// No description provided for @cycleLengthVarianceWidget_cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycleLengthVarianceWidget_cycle;

  /// No description provided for @periodDurationWidget_logAtLeastTwoPeriods.
  ///
  /// In en, this message translates to:
  /// **'Log at least two periods to see period statistics.'**
  String get periodDurationWidget_logAtLeastTwoPeriods;

  /// No description provided for @periodDurationWidget_title.
  ///
  /// In en, this message translates to:
  /// **'Period Duration Variance'**
  String get periodDurationWidget_title;

  /// No description provided for @periodDurationWidget_averagePeriod.
  ///
  /// In en, this message translates to:
  /// **'Avg. Period'**
  String get periodDurationWidget_averagePeriod;

  /// No description provided for @periodDurationWidget_period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get periodDurationWidget_period;

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

  /// No description provided for @painLevelWidget_noPainDataLoggedYet.
  ///
  /// In en, this message translates to:
  /// **'No pain data logged yet.'**
  String get painLevelWidget_noPainDataLoggedYet;

  /// No description provided for @painLevelWidget_painLevelBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Pain Level Breakdown'**
  String get painLevelWidget_painLevelBreakdown;

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

  /// A label showing the total number of pills.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{of 1 pill} other{of {count} pills}}'**
  String pillStatus_pillsOfTotal(int count);

  /// No description provided for @pillStatus_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get pillStatus_undo;

  /// No description provided for @pillStatus_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get pillStatus_skip;

  /// No description provided for @pillStatus_markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark As Taken'**
  String get pillStatus_markAsTaken;

  /// Message shown when the pill pack start date is in the future.
  ///
  /// In en, this message translates to:
  /// **'Your next pill pack starts on {date}.'**
  String pillStatus_packStartInFuture(DateTime date);

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

  /// No description provided for @larcEntrySheet_logLARCDetails.
  ///
  /// In en, this message translates to:
  /// **'Log LARC Details'**
  String get larcEntrySheet_logLARCDetails;

  /// No description provided for @sanitaryEntrySheet_logSanitaryProduct.
  ///
  /// In en, this message translates to:
  /// **'Log Sanitary Product'**
  String get sanitaryEntrySheet_logSanitaryProduct;

  /// No description provided for @sanitaryEntrySheet_setReminderDuration.
  ///
  /// In en, this message translates to:
  /// **'Set Reminder Duration'**
  String get sanitaryEntrySheet_setReminderDuration;

  /// Label showing the maximum duration for the selected sanitary product type.
  ///
  /// In en, this message translates to:
  /// **'Max Duration: {hours} hours'**
  String sanitaryEntrySheet_maxDuration(int hours);

  /// No description provided for @sanitaryEntrySheet_futureLogTimeError.
  ///
  /// In en, this message translates to:
  /// **'Log time cannot be in the future.'**
  String get sanitaryEntrySheet_futureLogTimeError;

  /// No description provided for @sanitaryEntrySheet_pastReminderTimeError.
  ///
  /// In en, this message translates to:
  /// **'Reminder end time cannot be in the past.'**
  String get sanitaryEntrySheet_pastReminderTimeError;

  /// A label showing the total number of days until period is due.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Day} other{Days}}'**
  String periodPredictionCircle_days(int count);

  /// No description provided for @customSymptomDialog_newSymptom.
  ///
  /// In en, this message translates to:
  /// **'New Symptom'**
  String get customSymptomDialog_newSymptom;

  /// No description provided for @customSymptomDialog_enterCustomSymptom.
  ///
  /// In en, this message translates to:
  /// **'Enter a custom symptom'**
  String get customSymptomDialog_enterCustomSymptom;

  /// No description provided for @customSymptomDialog_temporarySymptom.
  ///
  /// In en, this message translates to:
  /// **'Temporary Symptom'**
  String get customSymptomDialog_temporarySymptom;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'it',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
