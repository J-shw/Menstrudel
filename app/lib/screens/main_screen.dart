import 'package:flutter/material.dart';
import 'package:menstrudel/controllers/log_reversible_contraceptive_ui_controller.dart';
import 'package:menstrudel/controllers/log_sanitary_ui_controller.dart';
import 'package:menstrudel/controllers/log_sex_ui_controller.dart';
import 'package:menstrudel/controllers/log_ui_controller.dart';
import 'package:menstrudel/screens/dashboards/logs/logs_screen.dart';
import 'package:menstrudel/screens/dashboards/sanitary_screen.dart';
import 'package:menstrudel/screens/settings/settings_screen.dart';
import 'package:menstrudel/screens/dashboards/pills_screen.dart';
import 'package:menstrudel/screens/dashboards/sex/sex_screen.dart';
import 'package:menstrudel/services/user_service.dart';
import 'package:menstrudel/widgets/main/main_navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/screens/dashboards/reversible_contraceptive/reversible_contraceptive_screen.dart';

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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Builds Log screen FAB
  Widget _buildLogDayFab(BuildContext context, AppLocalizations l10n, int? age) {
    return FloatingActionButton(
      key: const ValueKey('log_day_fab'),
      tooltip: l10n.fabToolTip_logs,
      onPressed: () {
        context.read<LogUIController>().handleCreateNewLog(
              context: context,
              selectedDate: DateTime.now(),
              symptomService: context.read(),
              age: age,
            );
      },
      child: const Icon(Icons.add),
    );
  }

  /// Builds Sanitary screen FAB
  Widget _buildSanitaryFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('log_sanitary_fab'),
      tooltip: l10n.fabToolTip_sanitary,
      onPressed: () {
        context.read<LogSanitaryUIController>().handleCreateNewSanitaryLog(
              context: context,
            );
      },
      child: const Icon(Icons.add),
    );
  }

  /// Builds Sex screen FAB
  Widget _buildSexFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('log_sex_fab'),
      tooltip: l10n.fabToolTip_sexActivity,
      onPressed: () {
        context.read<LogSexUIController>().handleCreateNewSexLog(context: context);
      },
      child: const Icon(Icons.add),
    );
  }

  /// Builds Reversible contraceptive screen FAB
  Widget _buildReversibleContraceptiveFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('log_reversible_contraceptive_fab'),
      tooltip: l10n.fabToolTip_reversibleContraceptive,
      onPressed: () {
        context.read<LogReversibleContraceptiveUIController>().handleCreateNewReversibleContraceptiveLog(context: context);
      },
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();
    final userService = context.watch<UserService>();

    final bool isPillNavEnabled = settingsService.isPillNavEnabled;
    final bool isReversibleContraceptiveNavEnabled = settingsService.isReversibleContraceptiveNavEnabled;
    final bool isSanitaryNavEnabled = settingsService.isSanitaryNavEnabled;
    final bool isSexActivityNavEnabled = settingsService.isSexActivityNavEnabled;
      
    /// Define pages on enabled features
    final List<Widget> pages = <Widget>[
      const LogsScreen(),
      if (isSanitaryNavEnabled) const SanitaryScreen(),
      if (isSexActivityNavEnabled) const SexScreen(),
      if (isPillNavEnabled) const PillsScreen(),
      if (isReversibleContraceptiveNavEnabled) const ReversibleContraceptiveScreen(),
      const SettingsScreen(),
    ];

    /// Define app bars based on enabled features
    final List<PreferredSizeWidget?> appBars = [
      TopAppBar(titleText: l10n.mainScreen_logsPageTitle),
      if (isSanitaryNavEnabled)
        TopAppBar(titleText: l10n.mainScreen_sanitaryPageTitle),
      if (isSexActivityNavEnabled)
        TopAppBar(titleText: l10n.mainSceen_sexActivityPageTitle),
      if (isPillNavEnabled)
        TopAppBar(titleText: l10n.mainScreen_pillsPageTitle),
      if (isReversibleContraceptiveNavEnabled)
        TopAppBar(titleText: l10n.mainScreen_reversibleContraceptivesPageTitle),
      TopAppBar(titleText: l10n.mainScreen_settingsPageTitle),
    ];

    final List appFABs = [
      _buildLogDayFab(context, l10n, userService.age),
      if (isSanitaryNavEnabled) _buildSanitaryFab(context),
      if (isSexActivityNavEnabled) _buildSexFab(context),
      if (isPillNavEnabled) null,
      if (isReversibleContraceptiveNavEnabled) _buildReversibleContraceptiveFab(context),
      null,
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
      floatingActionButton: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: appFABs[correctedIndex],
            )
    );
  }
}