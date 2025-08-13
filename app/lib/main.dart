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
    final seedColor = const Color.fromARGB(255, 130, 172, 250);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menstrudel',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}