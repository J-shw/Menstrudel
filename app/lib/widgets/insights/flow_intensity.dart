import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class FlowBreakdownWidget extends StatelessWidget {
  final List<PeriodLogEntry> logs;
  const FlowBreakdownWidget({super.key, required this.logs});

  Widget _buildBar(BuildContext context, {required String label, required int count, required int total, required Color color}) {
    final textTheme = Theme.of(context).textTheme;
    final percentage = total > 0 ? (count / total) : 0.0;
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ($count ${l10n.days.toLowerCase()})', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          color: color,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    if (logs.isEmpty) {
        return Card(child: Padding(padding: EdgeInsets.all(24.0), child: Center(child: Text(l10n.flowIntensityWidget_noFlowDataLoggedYet))));
    }
    
    // --- Data Processing ---
    int lightDays = 0, mediumDays = 0, heavyDays = 0;
    for (final log in logs) {
        if (log.flow <= 1) {
          lightDays++;
        } else if (log.flow == 2) {
          mediumDays++;
        }
        else {
          heavyDays++;
        }
    }
    final totalDays = logs.length;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.flowIntensityWidget_flowIntensityBreakdown, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildBar(context, label: l10n.flowIntensity_light, count: lightDays, total: totalDays, color: Colors.pink.shade200),
            const SizedBox(height: 16),
            _buildBar(context, label: l10n.flowIntensity_moderate, count: mediumDays, total: totalDays, color: Colors.pink.shade400),
            const SizedBox(height: 16),
            _buildBar(context, label: l10n.flowIntensity_heavy, count: heavyDays, total: totalDays, color: Colors.red.shade700),
          ],
        ),
      ),
    );
  }
}