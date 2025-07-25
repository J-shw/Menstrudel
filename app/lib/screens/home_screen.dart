import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/basic_progress_circle.dart'; // Make sure this path is correct
import 'package:menstrudel/screens/add_symptom_screen.dart'; // Make sure this path is correct

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This context is now a descendant of MaterialApp, so Navigator.of(context) will work!
    return Scaffold(
      body: Center(
        child: BasicProgressCircle(
          currentValue: 7,
          maxValue: 30,
          circleSize: 220,
          strokeWidth: 20,
          // Keep hardcoded colors here if you desire them to override the theme
          progressColor: const Color.fromARGB(255, 255, 118, 118),
          trackColor: const Color.fromARGB(20, 255, 118, 118),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddSymptomScreen(),
            ),
          );
        },
        tooltip: 'Log symptoms',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}