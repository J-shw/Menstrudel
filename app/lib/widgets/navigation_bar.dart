import 'package:flutter/material.dart';
import 'package:menstrudel/screens/analytics_screen.dart';
import 'package:menstrudel/screens/home_screen.dart';


class MainBottomNavigationBar extends StatelessWidget {
  final bool isAnalyticsScreenActive;
  final bool isHomeScreenActive;
  
  const MainBottomNavigationBar({
    super.key,
    this.isAnalyticsScreenActive = false,
    this.isHomeScreenActive = false,
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, size: 30.0),
              tooltip: 'Settings',
              onPressed: () {
                
              },
            ),	
          ],
        )
      ),
    );
  }
}