
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

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

  /// Converts a string to the corresponding StartingDayOfWeek enum value.
  /// Defaults to Monday if no match is found.
  static DayOfWeek fromString(String day) {
    return DayOfWeek.values.firstWhere(
      (e) => e.value == day.toLowerCase(),
      orElse: () => DayOfWeek.monday,
    );
  }

  /// Converts to the TableCalendar StartingDayOfWeek enum.
  StartingDayOfWeek get toTableCalendar {
    return switch (this) {
      monday    => StartingDayOfWeek.monday,
      tuesday   => StartingDayOfWeek.tuesday,
      wednesday => StartingDayOfWeek.wednesday,
      thursday  => StartingDayOfWeek.thursday,
      friday    => StartingDayOfWeek.friday,
      saturday  => StartingDayOfWeek.saturday,
      sunday    => StartingDayOfWeek.sunday,
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