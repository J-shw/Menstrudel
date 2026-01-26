import 'package:flutter/material.dart';

class QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const QuickStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBg = backgroundColor ?? colorScheme.secondaryContainer.withValues(alpha: 0.5);
    final effectiveContentColor = textColor ?? colorScheme.onSecondaryContainer;
    final effectiveIconColor = iconColor ?? effectiveContentColor;

    return Card(
      elevation: 0,
      color: effectiveBg,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: effectiveIconColor,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: effectiveContentColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: effectiveContentColor.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}