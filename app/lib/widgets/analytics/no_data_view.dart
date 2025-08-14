import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  const NoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 60, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 20),
            Text(
              'Not enough data for insights yet.\nLog at least two periods.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}