import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';

class SexActivityUsageChart extends StatelessWidget {
  final List<SexLogEntry> historyEntries;

  const SexActivityUsageChart({super.key, required this.historyEntries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // Count occurrences of each sex type
    final counts = <SexTypes, int>{};
    for (var entry in historyEntries) {
      if (entry.sexType != null) {
        counts[entry.sexType!] = (counts[entry.sexType!] ?? 0) + 1;
      }
    }

    final maxCount = counts.values.isEmpty 
        ? 1 
        : counts.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.sexActivityScreen_activityDistribution,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: SexTypes.values.map((type) {
                final count = counts[type] ?? 0;
                final ratio = count / maxCount;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(type.icon, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(type.getDisplayName(l10n)),
                          ),
                          Text(
                            count.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 8,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}