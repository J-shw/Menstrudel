import 'package:flutter/material.dart';
import 'package:menstrudel/screens/logs_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';
import 'package:menstrudel/screens/insights_screen.dart';
import 'package:menstrudel/screens/pills_screen.dart';
import 'package:menstrudel/widgets/main/main_navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

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
  final GlobalKey<LogsScreenState> _logsScreenKey = GlobalKey<LogsScreenState>();
  FabState _fabState = FabState.logPeriod;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const InsightsScreen(),
      LogsScreen(
        key: _logsScreenKey,
        onFabStateChange: _onFabStateChange,
      ),
      const PillsScreen(),
      const SettingsScreen(),
    ];
  }

  void _onFabStateChange(FabState newState) {
    if (_fabState != newState) {
      setState(() {
        _fabState = newState;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (_fabState) {
      case FabState.setReminder:
        return FloatingActionButton(
          key: const ValueKey('set_reminder_fab'),
          tooltip: l10n.mainScreen_tooltipSetReminder,
          onPressed: () => _logsScreenKey.currentState?.handleTamponReminder(context),
          child: const Icon(Icons.add_alarm),
        );
      case FabState.cancelReminder:
        return FloatingActionButton(
          key: const ValueKey('cancel_reminder_fab'),
          tooltip: l10n.mainScreen_tooltipCancelReminder,
          onPressed: () => _logsScreenKey.currentState?.handleCancelReminder(),
          child: const Icon(Icons.alarm_off),
        );
      case FabState.logPeriod:
        return FloatingActionButton(
          key: const ValueKey('log_fab'),
          tooltip: l10n.mainScreen_tooltipLogPeriod,
          onPressed: () => _logsScreenKey.currentState?.handleLogPeriod(DateTime.now()),
          child: const Icon(Icons.add),
        );
    }
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final List<PreferredSizeWidget?> appBars = [
      TopAppBar(titleText: l10n.mainScreen_insightsPageTitle),
      null,
      TopAppBar(titleText: l10n.mainScreen_pillsPageTitle),
      TopAppBar(titleText: l10n.mainScreen_settingsPageTitle),
    ];

    return Scaffold(
      appBar: appBars[_selectedIndex],
      body: _pages[_selectedIndex],
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 1
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _buildFab(context),
            )
          : null,
    );
  }
}