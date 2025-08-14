import 'package:flutter/material.dart';
import 'package:menstrudel/screens/analytics_screen.dart';
import 'package:menstrudel/screens/home_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';

enum AppScreen { home, analytics, settings }

class MainBottomNavigationBar extends StatelessWidget {
  final AppScreen activeScreen;
  
  const MainBottomNavigationBar({
    super.key,
    required this.activeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: Colors.white,
      elevation: 2.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.bar_chart,
            label: 'Insights',
            isActive: activeScreen == AppScreen.analytics,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
              );
            },
          ),
          _NavBarItem(
            icon: Icons.home,
            label: 'Home',
            isActive: activeScreen == AppScreen.home,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          _NavBarItem(
            icon: Icons.settings,
            label: 'Settings',
            isActive: activeScreen == AppScreen.settings,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ), 
        ],
      )
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Theme.of(context).primaryColor : Colors.grey;

    return InkWell(
      onTap: isActive ? null : onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}