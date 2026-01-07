import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/sanitary_product_log_card.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/countdown_card.dart';

class SanitaryProductLogsTab extends StatelessWidget {
  final bool isLoading;
  final SanitaryProductsEntry? activeEntry;
  final List<SanitaryProductsEntry> historyEntries;
  final VoidCallback onRemoveActive;
  final VoidCallback onCancelActive;
  final Function(SanitaryProductsEntry) onTapEntry;

  const SanitaryProductLogsTab({
    super.key,
    required this.isLoading,
    required this.activeEntry,
    required this.historyEntries,
    required this.onRemoveActive,
    required this.onCancelActive,
    required this.onTapEntry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Active Entry (Countdown) ---
          if (activeEntry != null) ...[
            CountdownCard(
              entry: activeEntry!,
              l10n: l10n,
              onCancel: onCancelActive,
              onRemove: onRemoveActive,
            ),
            const SizedBox(height: 24),
          ],

          // --- History List ---
          Text(
            l10n.sanitaryProductsScreen_history(historyEntries.length),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          if (historyEntries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  l10n.sanitaryProductsScreen_noHistoryRecords,
                  style: TextStyle(color: colorScheme.outline),
                ),
              ),
            )
          else
            ...historyEntries.map((entry) {
              return SanitaryProductsLogCard(
                entry: entry,
                l10n: l10n,
                logDate: DateFormat('MMM d, h:mm a').format(entry.logTime),
                onTap: () => onTapEntry(entry),
              );
            }),

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }
}