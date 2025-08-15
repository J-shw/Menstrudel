import 'package:flutter/material.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';

class FlowBreakdownWidget extends StatelessWidget {
  final List<PeriodLogEntry> logs;
  const FlowBreakdownWidget({super.key, required this.logs});

  Widget _buildBar(BuildContext context, {required String label, required int count, required int total, required Color color}) {
    final textTheme = Theme.of(context).textTheme;
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label ($count days)', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          color: color,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (logs.isEmpty) {
        return const Card(child: Padding(padding: EdgeInsets.all(24.0), child: Center(child: Text("No flow data logged yet."))));
    }
    
    // --- Data Processing ---
    int lightDays = 0, mediumDays = 0, heavyDays = 0;
    for (final log in logs) {
        if (log.flow <= 1) lightDays++;
        else if (log.flow == 2) mediumDays++;
        else heavyDays++;
    }
    final totalDays = logs.length;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flow Intensity Breakdown', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildBar(context, label: 'Light', count: lightDays, total: totalDays, color: Colors.pink.shade200),
            const SizedBox(height: 16),
            _buildBar(context, label: 'Medium', count: mediumDays, total: totalDays, color: Colors.pink.shade400),
            const SizedBox(height: 16),
            _buildBar(context, label: 'Heavy', count: heavyDays, total: totalDays, color: Colors.red.shade700),
          ],
        ),
      ),
    );
  }
}