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
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/dialogs/reminder_countdown_dialog.dart';
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
  FabState _fabState = FabState.logPeriod;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleTamponReminderCountdown(PeriodService service) async {
    final dueDate = await NotificationService.getTamponReminderScheduledTime();

    if (dueDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.logScreen_couldNotCancelReminder)),
        );
      }
      return;
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ReminderCountdownDialog(
          dueDate: dueDate,
          onDelete: () => service.handleCancelReminder(context),
        ),
      );
    }
  }

  Widget _buildLogPeriodFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('log_fab'),
      tooltip: l10n.mainScreen_tooltipLogPeriod,
      onPressed: () =>
          context.read<PeriodService>().createNewLog(context, DateTime.now()),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildSetReminderFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      key: const ValueKey('set_reminder_fab'),
      tooltip: l10n.mainScreen_tooltipSetReminder,
      onPressed: () => context.read<PeriodService>().handleTamponReminder(context),
      child: const Icon(Icons.add_alarm),
    );
  }

  Widget _buildCountDownReminderFab(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final service = context.read<PeriodService>();
    return FloatingActionButton(
      key: const ValueKey('countdown_reminder_fab'),
      tooltip: l10n.mainScreen_tooltipCancelReminder,
      onPressed: () => _handleTamponReminderCountdown(service),
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
    final bool isLarcNavEnabled = settingsService.isLarcNavEnabled;
    final bool isReminderButtonAlwaysVisible =
        settingsService.areAlwaysShowReminderButtonEnabled;

    final List<Widget> pages = <Widget>[
      const InsightsScreen(),
      LogsScreen(
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
      if (isPillNavEnabled) const PillsScreen(),
      if (isLarcNavEnabled) const LarcScreen(),
      const SettingsScreen(),
    ];

    final List<PreferredSizeWidget?> appBars = [
      TopAppBar(titleText: l10n.mainScreen_insightsPageTitle),
      null,
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
              child: _buildFab(context, isReminderButtonAlwaysVisible),
            )
          : null,
    );
  }
}