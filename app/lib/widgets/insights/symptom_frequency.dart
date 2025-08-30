import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class SymptomFrequencyWidget extends StatelessWidget {
  final List<PeriodLogEntry> logs;
  const SymptomFrequencyWidget({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final Map<String, int> symptomCounts = {};
    for (final log in logs) {
      if (log.symptoms != null && log.symptoms!.isNotEmpty) {
        final symptomsList = log.symptoms!.map((s) => s.trim());
        for (final symptom in symptomsList) {
          symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
        }
      }
    }
    
    final sortedSymptoms = symptomCounts.entries.sortedBy<num>((e) => e.value).reversed.toList();
    
    if (sortedSymptoms.isEmpty) {
        return Card(child: Padding(padding: EdgeInsets.all(24.0), child: Center(child: Text(l10n.symptomFrequencyWidget_noSymptomsLoggedYet))));
    }

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.symptomFrequencyWidget_mostCommonSymptoms, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...List.generate(sortedSymptoms.length.clamp(0, 5), (index) {
                final entry = sortedSymptoms[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${entry.value} days',
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