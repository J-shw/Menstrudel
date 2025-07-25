import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart';

void main() {
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(
				useMaterial3: true,
				// Define your light color scheme
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.blue, // A vibrant red for light mode progress
					brightness: Brightness.light,
				),
				appBarTheme: const AppBarTheme(
					backgroundColor: Colors.red, // Example app bar color for light theme
					foregroundColor: Colors.white, // Text color for app bar
				),
			),
			darkTheme: ThemeData(
				useMaterial3: true,
				// Define your dark color scheme
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.blue, // Using the same seed color helps maintain consistency
					brightness: Brightness.dark,
				),
				appBarTheme: AppBarTheme(
					backgroundColor: Colors.red[900], // Darker red for dark mode app bar
					foregroundColor: Colors.white,
				),
			),
			themeMode: ThemeMode.system, 
			home: Scaffold(
				// backgroundColor: Colors.white,
				body: Center(
					child: BasicProgressCircle(
						currentValue: 7, // Example: 7 days left
						maxValue: 30,  // Out of 30 days total
						circleSize: 220,
						strokeWidth: 20,
						progressColor: Color.fromARGB(255, 255, 118, 118),
						trackColor: Color.fromARGB(20, 255, 118, 118),
					),
				),
				floatingActionButton: FloatingActionButton(
					onPressed:
						() => true,
					tooltip: 'Log symptoms',
					child: const Icon(Icons.add),
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
			),
		);
	}
}
