import 'package:menstrudel/models/app/user_goal_types_enum.dart';

/// Use to enable/disable settings based off app goal.
/// Currently only the sexual tracking and sanitary tracking are automatically set.
/// This is because the LARC and Pill screen requires setup + users usually only use one or the other.
class GoalPreset {
  final bool sexNav;
  final bool sanitaryNav;

  const GoalPreset({
    required this.sexNav,
    required this.sanitaryNav,
  });
}

final Map<UserGoalTypes, GoalPreset> kGoalPresets = {
  UserGoalTypes.general: const GoalPreset(
    sexNav: false,
    sanitaryNav: true,
  ),
  UserGoalTypes.sexual: const GoalPreset(
    sexNav: true,
    sanitaryNav: true,
  ),
  UserGoalTypes.conceive: const GoalPreset(
    sexNav: true,
    sanitaryNav: false,
  ),
  UserGoalTypes.avoid: const GoalPreset(
    sexNav: true,
    sanitaryNav: true,
  ),
};