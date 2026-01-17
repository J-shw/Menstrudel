import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/app/user_goal_types_enum.dart';
import 'package:menstrudel/widgets/goal_card.dart';

class GoalStep extends StatelessWidget {
  final UserGoalTypes selectedGoal;
  final ValueChanged<UserGoalTypes> onGoalChanged;

  const GoalStep({
    super.key,
    required this.selectedGoal,
    required this.onGoalChanged,
  });

  Widget _buildContraceptionHint(BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    final showHint = selectedGoal == UserGoalTypes.avoid || selectedGoal == UserGoalTypes.sexual;

    if (!showHint) return const SizedBox.shrink();

    return Container(
      key: ValueKey(selectedGoal),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.secondaryContainer),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.onSecondaryContainer),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.onboardingScreen_contraceptionHint(l10n.settingsScreen_birthControl), 
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (l10n == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingScreen_goalTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingScreen_goalDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: UserGoalTypes.values.map((goal) {
              final isSelected = goal == selectedGoal;
              return GoalCard(
                title: goal.getDisplayName(l10n),
                icon: goal.icon,
                isSelected: isSelected,
                onTap: () => onGoalChanged(goal),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildContraceptionHint(context, l10n, colorScheme),
          ),
        ],
      ),
    );
  }
}