import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/user_service.dart';
import 'package:menstrudel/widgets/goal_card.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/models/app/user_goal_types_enum.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userService = context.watch<UserService>();
    final SettingsService settingsService = context.watch<SettingsService>();

    _nameController = TextEditingController(text: userService.user?.name ?? '');
    _selectedDate = userService.user?.birthDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_profile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.settingsScreen_name,
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 24),

          _buildSelectionCard(
            context,
            title: l10n.settingsScreen_birthDate,
            subtitle: userService.user?.birthDate != null 
                ? "${userService.user?.birthDate!.day}/${userService.user?.birthDate!.month}/${_selectedDate!.year}"
                : l10n.settingsScreen_notSet,
            icon: Icons.cake_outlined,
            onTap: () async {
              final pickedDob = await showDatePicker(
                context: context,
                initialDate: userService.user?.birthDate ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDob != null) setState(() => userService.setBirthDate(pickedDob));
            },
            trailing: userService.user?.birthDate != null 
                ? IconButton(
                    icon: const Icon(Icons.close), 
                    onPressed: () => setState(() => userService.removeBirthDate())
                  )
                : null,
          ),
          const SizedBox(height: 32),

          Text(l10n.settingsScreen_appGoal, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: UserGoalTypes.values.map((goal) {
              final isSelected = goal == userService.user?.primaryGoal;
              return GoalCard(
                title: goal.getDisplayName(l10n),
                isSelected: isSelected,
                icon:goal.icon,
                onTap: () => setState(() => userService.setPrimaryGoal(goal, settingsService)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context, 
      {required String title, required String subtitle, required IconData icon, required VoidCallback onTap, Widget? trailing}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}