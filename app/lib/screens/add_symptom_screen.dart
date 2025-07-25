import 'package:flutter/material.dart';

class AddSymptomScreen extends StatelessWidget {
  const AddSymptomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme's color scheme for adaptive colors
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Symptoms'),
        // The back button is automatically added by Scaffold when pushed
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is where you will add your symptoms!',
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface, // Adapts to light/dark mode
              ),
            ),
            const SizedBox(height: 20),
            // You'll add your symptom input fields, date pickers, etc., here later
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}