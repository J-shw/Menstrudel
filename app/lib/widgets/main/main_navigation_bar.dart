import 'package:flutter/material.dart';

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
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.bar_chart_rounded),
          icon: Icon(Icons.bar_chart_sharp),
          label: 'Insights',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.book),
          icon: Icon(Icons.book_outlined),
          label: 'Logs',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.medication_rounded),
          icon: Icon(Icons.medication_outlined),
          label: 'Pill',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}