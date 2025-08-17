import 'package:flutter/material.dart';

class EmptyPillsState extends StatelessWidget {
  const EmptyPillsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medication_liquid_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No pill regimen found.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'Set up your pill pack in settings to start tracking.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}