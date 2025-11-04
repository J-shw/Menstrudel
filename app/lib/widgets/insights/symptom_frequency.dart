import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/symptom.dart';

class SymptomFrequencyWidget extends StatelessWidget {
  final Map<Symptom, int> symptomCounts;
  const SymptomFrequencyWidget({super.key, required this.symptomCounts});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    
    final sortedSymptoms = symptomCounts.entries.sortedBy<num>((e) => e.value).reversed.toList();
    
    if (sortedSymptoms.isEmpty) {
      return Card(child: Padding(padding: const EdgeInsets.all(24.0), child: Center(child: Text(l10n.symptomFrequencyWidget_noSymptomsLoggedYet))));
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.symptomFrequencyWidget_mostCommonSymptoms, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...List.generate(sortedSymptoms.length.clamp(0, 5), (index) {
                final entry = sortedSymptoms[index];
                final Symptom symptom = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          symptom.getDisplayName(l10n),
                          maxLines: 1,
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.dayCount(entry.value),
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
}