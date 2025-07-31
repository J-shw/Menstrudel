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
		return MaterialApp(
			theme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.blue,
					brightness: Brightness.light,
				),
				appBarTheme: const AppBarTheme(
					backgroundColor: Color.fromARGB(255, 236, 102, 102),
					foregroundColor: Colors.white,
				),
			),
			darkTheme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.blue,
					brightness: Brightness.dark,
				),
				appBarTheme: AppBarTheme(
					backgroundColor: Colors.red[900],
					foregroundColor: Colors.white,
				),
			),
			themeMode: ThemeMode.system, 

			home: const HomeScreen(),
		);
	}
}
