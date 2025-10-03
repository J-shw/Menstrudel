import 'package:flutter/material.dart';
import 'package:menstrudel/screens/logs_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';
import 'package:menstrudel/screens/insights_screen.dart';
import 'package:menstrudel/screens/pills_screen.dart';
import 'package:menstrudel/widgets/main/main_navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';

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
  late final List<Widget> _pages;

  final SettingsService _settingsService = SettingsService();
  bool _isLoading = true;
  bool _isReminderButtonAlwaysVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
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

  Future<void> _loadSettings() async {
    final isEnabled =
        await _settingsService.areAlwaysShowReminderButtonEnabled();
    if (mounted) {
      setState(() {
        _isReminderButtonAlwaysVisible = isEnabled;
        _isLoading = false;
      });
    }
  }

  void _onFabStateChange(FabState suggestedState) {
    FabState finalState;

    if (_isReminderButtonAlwaysVisible) {
      if (suggestedState == FabState.cancelReminder) {
        finalState = FabState.cancelReminder;
      } else {
        finalState = FabState.setReminder;
      }
    } else {
      finalState = suggestedState;
    }

    if (_fabState != finalState) {
      setState(() {
        _fabState = finalState;
      });
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      await _loadSettings();
    }
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

  Widget _buildCancelReminderFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('cancel_reminder_fab'),
      tooltip: l10n.mainScreen_tooltipCancelReminder,
      onPressed: () => _logsScreenKey.currentState?.handleCancelReminder(),
      child: const Icon(Icons.alarm_off),
    );
  }

  Widget _buildFab(BuildContext context) {
    if (_isReminderButtonAlwaysVisible) {
      final Widget reminderFab = _fabState == FabState.cancelReminder
          ? _buildCancelReminderFab(context)
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
        return _buildCancelReminderFab(context);
      case FabState.logPeriod:
        return _buildLogPeriodFab(context);
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
      floatingActionButton: !_isLoading && _selectedIndex == 1
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