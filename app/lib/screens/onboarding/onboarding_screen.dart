import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/models/app/user_entry.dart';
import 'package:menstrudel/models/app/user_goal_types_enum.dart';
import 'package:menstrudel/database/repositories/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/welcome_step.dart';
import 'widgets/profile_step.dart';
import 'widgets/goal_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  DateTime? _selectedDate;
  UserGoalTypes _selectedGoal = UserGoalTypes.general;
  int _currentPage = 0;

  void _finish() async {
    if (_nameController.text.isEmpty) return;
    final newUser = UserEntry(
      name: _nameController.text,
      birthDate: _selectedDate,
      primaryGoal: _selectedGoal,
    );
    await context.read<UserService>().updateUser(newUser);
    if (mounted){
      await context.read<SettingsService>().applySettingsForGoal(_selectedGoal);
    }
    if (mounted) Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  const WelcomeStep(),
                  ProfileStep(
                    nameController: _nameController,
                    selectedDate: _selectedDate,
                    onDateTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(
                          DateTime.now().year - 5,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    onDateClear: () => setState(() => _selectedDate = null),
                  ),
                  GoalStep(
                    selectedGoal: _selectedGoal,
                    onGoalChanged: (goal) =>
                        setState(() => _selectedGoal = goal),
                  ),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final isLastPage = _currentPage == 2;
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () => _currentPage < 2
                  ? _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    )
                  : _finish(),
              child: Text(
                isLastPage ? l10n.onboardingScreen_getStarted : l10n.next,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_currentPage > 0)
            TextButton(
              onPressed: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
              child: Text(l10n.back),
            )
          else
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  l10n.onBoardingScreen_byUsingMenstrudelYouAgreeTo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                GestureDetector(
                  onTap: () =>
                      launchUrl(Uri.parse('https://menstrudel.app/privacy/')),
                  child: Text(
                    l10n.onBoardingScreen_privacyPolicy,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
