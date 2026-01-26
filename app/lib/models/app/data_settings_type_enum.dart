import 'package:menstrudel/l10n/app_localizations.dart';

/// An enum representing different types of data settings in the application.
/// Used for selecting data types for export, import, or deletion.
enum DataType {
  logsAndPeriods,
  pills,
  sanitaryProducts,
  reversibleContraceptives,
  sexualActivity;

  /// The file name to be used for export/import operations.
  String fileName() {
    return switch (this) {
      DataType.logsAndPeriods => 'logs_and_periods',
      DataType.pills => 'pills',
      DataType.sanitaryProducts => 'sanitary_products',
      DataType.reversibleContraceptives => 'reversible_contraceptives',
      DataType.sexualActivity => 'sexual_activity',
    };
  }

  String clearTitle(AppLocalizations l10n) {
    return switch (this) {
      DataType.logsAndPeriods => l10n.settingsScreen_clearLogsAndPeriods,
      DataType.pills => l10n.settingsScreen_clearPillLogs,
      DataType.sanitaryProducts => l10n.settingsScreen_clearSanitaryProductLogs,
      DataType.reversibleContraceptives => l10n.settingsScreen_clearReversibleContraceptiveLogs,
      DataType.sexualActivity => l10n.settingsScreen_clearSexualActivityLogs,
    };
  }

  String clearSubtitle(AppLocalizations l10n) {
    return switch (this) {
      DataType.logsAndPeriods => l10n.settingsScreen_clearLogsAndPeriodsSubtitle,
      DataType.pills => l10n.settingsScreen_clearPillLogsSubtitle,
      DataType.sanitaryProducts => l10n.settingsScreen_clearSanitaryProductLogsSubtitle,
      DataType.reversibleContraceptives => l10n.settingsScreen_clearReversibleContraceptiveLogsSubtitle,
      DataType.sexualActivity => l10n.settingsScreen_clearSexualActivityLogsSubtitle,
    };
  }
}