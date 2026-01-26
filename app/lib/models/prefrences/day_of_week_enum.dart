import 'package:menstrudel/l10n/app_localizations.dart';

/// Enum representing the starting day of the week.
/// Currently used for calendar displays.
enum DayOfWeek {
  monday('monday'),
  tuesday('tuesday'),
  wednesday('wednesday'),
  thursday('thursday'),
  friday('friday'),
  saturday('saturday'),
  sunday('sunday');

  final String value;
  const DayOfWeek(this.value);

  /// Converts a string to the corresponding DayOfWeek enum value.
  /// Defaults to Monday if no match is found.
  static DayOfWeek fromString(String day) {
    return DayOfWeek.values.firstWhere(
      (e) => e.value == day.toLowerCase(),
      orElse: () => DayOfWeek.monday,
    );
  }

  /// Converts to a DateTime enum for use with ScrollableCleanCalendar.
  int get toTableCalendar {
    return switch (this) {
      monday    => DateTime.monday,
      tuesday   => DateTime.tuesday,
      wednesday => DateTime.wednesday,
      thursday  => DateTime.thursday,
      friday    => DateTime.friday,
      saturday  => DateTime.saturday,
      sunday    => DateTime.sunday,
    };
  }

  /// Returns the localised display name for the day of the week.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      monday => l10n.dayOfWeek_monday,
      tuesday => l10n.dayOfWeek_tuesday,
      wednesday => l10n.dayOfWeek_wednesday,
      thursday => l10n.dayOfWeek_thursday,
      friday => l10n.dayOfWeek_friday,
      saturday => l10n.dayOfWeek_saturday,
      sunday => l10n.dayOfWeek_sunday,
    };
  }
}