import 'package:flutter/material.dart';
import 'package:menstrudel/screens/analytics_screen.dart';
import 'package:menstrudel/screens/home_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';


class MainBottomNavigationBar extends StatelessWidget {
  final bool isAnalyticsScreenActive;
  final bool isHomeScreenActive;
  final bool isSettingScreenActive;
  
  const MainBottomNavigationBar({
    super.key,
    this.isAnalyticsScreenActive = false,
    this.isHomeScreenActive = false,
    this.isSettingScreenActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.bar_chart, size: 30.0),
              tooltip: 'Analytics',
              onPressed: isAnalyticsScreenActive
              ? null
              : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home, size: 30.0),
              tooltip: 'Home',
              onPressed: isHomeScreenActive
              ? null
              : () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, size: 30.0),
              tooltip: 'Settings',
              onPressed: isSettingScreenActive
              ? null
              : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),	
          ],
        )
      ),
    );
  }
}