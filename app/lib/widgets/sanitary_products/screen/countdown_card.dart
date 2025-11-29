import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart'; 
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';

class CountdownCard extends StatelessWidget {
  const CountdownCard({
    super.key,
    required this.entry,
    required this.l10n,
    required this.onCancel,
    required this.onRemove,
  });

  final SanitaryProductsEntry entry;
  final AppLocalizations l10n;
  final VoidCallback onCancel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final endTime = entry.reminderTime;
    final remaining = endTime.difference(DateTime.now());
    final displayDuration = remaining.isNegative ? Duration.zero : remaining;
    
    final hours = displayDuration.inHours.toString().padLeft(2, '0');
    final minutes = displayDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = displayDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(entry.type.getIcon(), color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                l10n.sanitaryProductsScreen_activeProduct(entry.type.getDisplayName(l10n)),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "$hours:$minutes:$seconds",
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.sanitaryProductsScreen_changeDueAt(DateFormat.jm().format(endTime)),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FilledButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
                label: Text(l10n.cancel),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                ),
              ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.check),
                label: Text(l10n.removed),
              ),
              ),
            ],
          )
        ],
      ),
    );
  }
}