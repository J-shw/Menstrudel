import 'package:flutter/material.dart';
import 'package:menstrudel/screens/logs_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';
import 'package:menstrudel/screens/insights_screen.dart';
import 'package:menstrudel/screens/pills_screen.dart';
import 'package:menstrudel/widgets/main/main_navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';

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
  final GlobalKey<LogsScreenState> _logsScreenKey =
      GlobalKey<LogsScreenState>();
  FabState _fabState = FabState.logPeriod;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLogPeriodFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('log_fab'),
      tooltip: l10n.mainScreen_tooltipLogPeriod,
      onPressed: () =>
          _logsScreenKey.currentState?.createNewLog(DateTime.now()),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildSetReminderFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('set_reminder_fab'),
      tooltip: l10n.mainScreen_tooltipSetReminder,
      onPressed: () =>
          _logsScreenKey.currentState?.handleTamponReminder(context),
      child: const Icon(Icons.add_alarm),
    );
  }

  Widget _buildCountDownReminderFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('countdown_reminder_fab'),
      tooltip: l10n.mainScreen_tooltipCancelReminder,
      onPressed: () => _logsScreenKey.currentState?.handleTamponReminderCountdown(),
      child: const Icon(Icons.timer),
    );
  }

  Widget _buildFab(BuildContext context, bool isReminderButtonAlwaysVisible) {
    if (isReminderButtonAlwaysVisible) {
      final Widget reminderFab = _fabState == FabState.cancelReminder
          ? _buildCountDownReminderFab(context)
          : _buildSetReminderFab(context);

      return Column(
        key: const ValueKey('multi_fab'),
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          reminderFab,
          const SizedBox(height: 16),
          _buildLogPeriodFab(context),
        ],
      );
    }

    switch (_fabState) {
      case FabState.setReminder:
        return _buildSetReminderFab(context);
      case FabState.cancelReminder:
        return _buildCountDownReminderFab(context);
      case FabState.logPeriod:
        return _buildLogPeriodFab(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();

    final bool isPillNavEnabled = settingsService.isPillNavEnabled;
    final bool isReminderButtonAlwaysVisible =
        settingsService.areAlwaysShowReminderButtonEnabled;

    final List<Widget> pages = <Widget>[
      const InsightsScreen(),
      LogsScreen(
        key: _logsScreenKey,
        onFabStateChange: (FabState suggestedState) {
          FabState finalState;
          if (isReminderButtonAlwaysVisible) {
            finalState = (suggestedState == FabState.cancelReminder)
                ? FabState.cancelReminder
                : FabState.setReminder;
          } else {
            finalState = suggestedState;
          }

          if (_fabState != finalState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _fabState = finalState;
                });
              }
            });
          }
        },
        isReminderButtonAlwaysVisible: isReminderButtonAlwaysVisible,
      ),
      if (isPillNavEnabled)
        const PillsScreen(),
      const SettingsScreen(),
    ];

    final List<PreferredSizeWidget?> appBars = [
      TopAppBar(titleText: l10n.mainScreen_insightsPageTitle),
      null,
      if (isPillNavEnabled)
        TopAppBar(titleText: l10n.mainScreen_pillsPageTitle),
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
              child: _buildFab(context, isReminderButtonAlwaysVisible),
            )
          : null,
    );
  }
}