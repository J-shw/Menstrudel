import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class PillStatusCard extends StatelessWidget {
  final int currentPillNumberInCycle;
  final int totalPills;
  final bool isTodayPillTaken;
  final VoidCallback onTakePill;
  final VoidCallback onSkipPill;
  final VoidCallback undoTakePill;
  final DateTime packStartDate;

  const PillStatusCard({
    super.key,
    required this.currentPillNumberInCycle,
    required this.totalPills,
    required this.isTodayPillTaken,
    required this.onTakePill,
    required this.onSkipPill,
    required this.undoTakePill,
    required this.packStartDate,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = totalPills > 0 ? currentPillNumberInCycle / totalPills : 0.0;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    final buttonStyle = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final packStartDateOnly = DateTime(packStartDate.year, packStartDate.month, packStartDate.day);
    final isPackStartInFuture = packStartDateOnly.isAfter(todayDateOnly);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  year2023: false,
                  value: progressValue,
                  strokeWidth: 15,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentPillNumberInCycle',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      l10n.pillStatus_pillsOfTotal(totalPills),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isPackStartInFuture)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 60,
                    color: primaryColor.withAlpha(60),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.pillStatus_packStartInFuture(packStartDateOnly),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          else if (isTodayPillTaken)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: undoTakePill,
                icon: const Icon(Icons.undo),
                label: Text(l10n.pillStatus_undo),
                style: buttonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.grey[600]),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSkipPill,
                    icon: const Icon(Icons.skip_next_rounded),
                    label: Text(l10n.pillStatus_skip),
                    style: buttonStyle.copyWith(
                      side: WidgetStateProperty.all(BorderSide(color: primaryColor)),
                      foregroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onTakePill,
                    icon: const Icon(Icons.medical_services_rounded),
                    label: Text(l10n.pillStatus_markAsTaken),
                    style: buttonStyle.copyWith(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}