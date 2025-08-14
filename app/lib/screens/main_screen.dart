import 'package:flutter/material.dart';
import 'package:menstrudel/screens/analytics_screen.dart';
import 'package:menstrudel/screens/home_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';
import 'package:menstrudel/widgets/main/navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _pages = <Widget>[
    AnalyticsScreen(),
    HomeScreen(),
    SettingsScreen(),
  ];
  
  static const List<PreferredSizeWidget?> _appBars = <PreferredSizeWidget?>[
    TopAppBar(titleText: "Analytics"),
    null,
    TopAppBar(titleText: "Settings"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedIndex],
      body: _pages[_selectedIndex],
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: _selectedIndex,
        onScreenSelected: _onItemTapped,
      ),
    );
  }
}