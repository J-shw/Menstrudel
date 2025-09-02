import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';


class PeriodDetailsBottomSheet extends StatelessWidget {
  final PeriodLogEntry log;
  final VoidCallback onDelete;

  const PeriodDetailsBottomSheet({
    super.key,
    required this.log,
    required this.onDelete,
  });

  String _getFlowLabel(BuildContext context, int flow) {
    final l10n = AppLocalizations.of(context)!;
    switch (flow) {
      case 1:
        return l10n.flowIntensity_light;
      case 2:
        return l10n.flowIntensity_moderate;
      case 3:
        return l10n.flowIntensity_heavy;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header with date and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(log.date),
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 24, color: colorScheme.error),
                onPressed: onDelete,
              ),
            ],
          ),
          const Divider(height: 24),

          // Flow details
          Row(
            children: [
              Icon(Icons.opacity, color: colorScheme.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Text('${l10n.periodDetailsSheet_flow}: ', style: textTheme.bodyLarge),
              Text(
                _getFlowLabel(context, log.flow),
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ...List.generate(
                3,
                (index) => Icon(
                  index < log.flow + 1 ? Icons.water_drop : Icons.water_drop_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Symptoms section
          if (log.symptoms != null && log.symptoms!.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.bubble_chart_outlined, color: colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 12),
                Text('${l10n.periodDetailsSheet_symptons}:', style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: log.symptoms!.map((s) => Chip(label: Text(s))).toList(),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}