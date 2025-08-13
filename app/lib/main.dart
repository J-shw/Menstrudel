import 'package:flutter/material.dart';
import 'package:menstrudel/screens/home_screen.dart';
import 'package:menstrudel/services/period_notifications.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialiseNotifications(); 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightSeedColor = const Color(0xFF3B82F6);
	final darkSeedColor = const Color(0xFF60A5FA);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menstrudel',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: lightSeedColor,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkSeedColor,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}