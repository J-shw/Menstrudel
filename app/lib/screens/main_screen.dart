import 'package:flutter/material.dart';
import 'package:menstrudel/controllers/log_ui_controller.dart';
import 'package:menstrudel/screens/logs_screen.dart';
import 'package:menstrudel/screens/sanitary_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';
import 'package:menstrudel/screens/insights_screen.dart';
import 'package:menstrudel/screens/pills_screen.dart';
import 'package:menstrudel/widgets/main/main_navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/screens/larc_screen.dart';

enum FabState {
  logPeriod,
  setReminder,
  cancelReminder,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLogDayFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('log_fab'),
      tooltip: l10n.mainScreen_tooltipLogPeriod, //TODO: Change to log day (No longer just periods)
      onPressed: () {
        context.read<LogUIController>().handleCreateNewLog(
              context: context,
              selectedDate: DateTime.now(),
            );
      },
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();

    final bool isPillNavEnabled = settingsService.isPillNavEnabled;
    final bool isLarcNavEnabled = settingsService.isLarcNavEnabled;
    final bool isSanitaryNavEnabled = settingsService.isSanitaryNavEnabled;
      
    /// Define pages on enabled features
    final List<Widget> pages = <Widget>[
      const InsightsScreen(),
      const LogsScreen(),
      if (isSanitaryNavEnabled) const SanitaryScreen(),
      if (isPillNavEnabled) const PillsScreen(),
      if (isLarcNavEnabled) const LarcScreen(),
      const SettingsScreen(),
    ];

    /// Define app bars based on enabled features
    final List<PreferredSizeWidget?> appBars = [
      TopAppBar(titleText: l10n.mainScreen_insightsPageTitle),
      null,
      TopAppBar(titleText: l10n.mainScreen_sanitaryPageTitle),
      if (isPillNavEnabled)
        TopAppBar(titleText: l10n.mainScreen_pillsPageTitle),
      if (isLarcNavEnabled)
        TopAppBar(titleText: l10n.mainScreen_LarcsPageTitle),
      TopAppBar(titleText: l10n.mainScreen_settingsPageTitle),
    ];

    int correctedIndex = _selectedIndex;
    if (_selectedIndex >= pages.length) {
      correctedIndex = pages.length - 1;
    }

    return Scaffold(
      appBar: appBars[correctedIndex],
      body: pages[correctedIndex],
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: correctedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      floatingActionButton: correctedIndex == 1
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _buildLogDayFab(context),
            )
          : null,
    );
  }
}