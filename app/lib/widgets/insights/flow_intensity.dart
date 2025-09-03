import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/flow_enum.dart';

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
        Text('$label (${l10n.dayCount(count)})', style: textTheme.bodyMedium),
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

    final flowCounts = {
      for (var flow in FlowRate.values) flow: 0
    };

    for (final log in logs) {
      final flow = FlowRate.values[log.flow];
      flowCounts[flow] = (flowCounts[flow] ?? 0) + 1;
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
            ...FlowRate.values.expand((flow) => [
              _buildBar(
                context, 
                label: flow.getDisplayName(l10n), 
                count: flowCounts[flow]!, 
                total: totalDays, 
                color: flow.color,
              ),
              if (flow != FlowRate.values.last)
                const SizedBox(height: 16),
            ]),
          ],
        ),
      ),
    );
  }
}