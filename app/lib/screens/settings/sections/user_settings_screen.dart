import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/goal_card.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/user_repository.dart';
import 'package:menstrudel/models/app/user_entry.dart';
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
  UserGoalTypes? _selectedGoal;
  UserEntry? _initialUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await context.read<UserRepository>().getUser();
    if (user != null) {
      setState(() {
        _initialUser = user;
        _nameController = TextEditingController(text: user.name);
        _selectedDate = user.birthDate;
        _selectedGoal = user.primaryGoal;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_initialUser == null) return;
    final l10n = AppLocalizations.of(context)!;

    final updatedUser = _initialUser!.copyWith(
      name: _nameController.text,
      birthDate: _selectedDate,
      primaryGoal: _selectedGoal,
    );

    await context.read<UserRepository>().updateUser(updatedUser);

    if (mounted) await context.read<SettingsService>().applySettingsForGoal(_selectedGoal!);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsScreen_profileUpdated)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_profile),
        actions: [
          IconButton(onPressed: _saveChanges, icon: const Icon(Icons.check)),
        ],
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
            subtitle: _selectedDate != null 
                ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                : l10n.settingsScreen_notSet,
            icon: Icons.cake_outlined,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            trailing: _selectedDate != null 
                ? IconButton(
                    icon: const Icon(Icons.close), 
                    onPressed: () => setState(() => _selectedDate = null)
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
              final isSelected = goal == _selectedGoal;
              return GoalCard(
                title: goal.getDisplayName(l10n),
                isSelected: isSelected,
                icon:goal.icon,
                onTap: () => setState(() => _selectedGoal = goal),
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