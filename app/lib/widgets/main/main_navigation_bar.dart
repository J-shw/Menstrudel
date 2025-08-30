import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.bar_chart_rounded),
          icon: Icon(Icons.bar_chart_sharp),
          label: l10n.navBar_insights,
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.book),
          icon: Icon(Icons.book_outlined),
          label: l10n.navBar_logs,
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.medication_rounded),
          icon: Icon(Icons.medication_outlined),
          label: l10n.navBar_pill,
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: l10n.navBar_settings,
        ),
      ],
    );
  }
}