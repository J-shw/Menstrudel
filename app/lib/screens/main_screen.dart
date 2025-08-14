import 'package:flutter/material.dart';
import 'package:menstrudel/screens/analytics_screen.dart';
import 'package:menstrudel/screens/home_screen.dart';
import 'package:menstrudel/screens/settings_screen.dart';
import 'package:menstrudel/widgets/main/main_navigation_bar.dart';
import 'package:menstrudel/widgets/main/app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final GlobalKey<HomeScreenState> _homeScreenKey = GlobalKey<HomeScreenState>();
  
  bool _isPeriodOngoing = false;

  late final List<Widget> _pages;
  static const List<PreferredSizeWidget?> _appBars = <PreferredSizeWidget?>[
    TopAppBar(titleText: "Insights"),
    null,
    TopAppBar(titleText: "Settings"),
  ];

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const AnalyticsScreen(),
      HomeScreen(
        key: _homeScreenKey,
        onPeriodStatusChange: _onPeriodStatusChange,
      ),
      const SettingsScreen(),
    ];
  }

  void _onPeriodStatusChange(bool isOngoing) {
    if (_isPeriodOngoing != isOngoing) {
      setState(() {
        _isPeriodOngoing = isOngoing;
      });
    }
  }

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

    floatingActionButton: _selectedIndex == 1 
      ? AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: _isPeriodOngoing
          ? FloatingActionButton(
              key: const ValueKey('tampon_fab'),
              tooltip: 'Tampon reminder',
              onPressed: () => _homeScreenKey.currentState?.handleTamponReminder(context),
              child: const Icon(Icons.add_alarm),
            )
          : FloatingActionButton(
              key: const ValueKey('log_fab'),
              tooltip: 'Log period',
              onPressed: () => _homeScreenKey.currentState?.handleLogPeriod(context),
              child: const Icon(Icons.add),
            ),
      )
    : null,
    );
  }
}