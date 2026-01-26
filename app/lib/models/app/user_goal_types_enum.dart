import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/app/settings_presets.dart';

/// Enum representing different types of user app goals.
enum UserGoalTypes {
  /// For users tracking periods for general health.
  general('general'),
  /// For users focusing on sexual health.
  sexual('sexual'),
  /// For users trying to conceive.
  conceive('conceive'),
  /// For users trying to avoid pregnancy.
  avoid('avoid');

  /// The string identifier used for database storage.
  final String dbName;

  const UserGoalTypes(this.dbName);

  /// Converts a database string back into a [UserGoalTypes].
  static UserGoalTypes fromDbName(String value) {
    return UserGoalTypes.values.firstWhere(
      (e) => e.dbName == value,
      orElse: () => UserGoalTypes.general,
    );
  }

  /// Returns the localised string for the UI.
  String getDisplayName(AppLocalizations l10n) {
    return switch (this) {
      UserGoalTypes.general => l10n.userGoal_general,
      UserGoalTypes.sexual => l10n.userGoal_sexual,
      UserGoalTypes.conceive => l10n.userGoal_conceive,
      UserGoalTypes.avoid => l10n.userGoal_avoid,
    };
  }

  /// gets the associated icon for the goal type.
  IconData get icon {
    return switch (this) {
      UserGoalTypes.general => Icons.health_and_safety,
      UserGoalTypes.sexual => Icons.favorite,
      UserGoalTypes.conceive => Icons.child_friendly,
      UserGoalTypes.avoid => Icons.shield,
    };
  }
}

extension UserGoalExtension on UserGoalTypes {
  GoalPreset get settings => kGoalPresets[this]!;
}