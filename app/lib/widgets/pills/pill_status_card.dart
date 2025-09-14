import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class PillStatusCard extends StatelessWidget {
  final int currentPillNumberInCycle;
  final int totalPills;
  final bool isTodayPillTaken;
  final VoidCallback onTakePill;
  final VoidCallback undoTakePill;

  const PillStatusCard({
    super.key,
    required this.currentPillNumberInCycle,
    required this.totalPills,
    required this.isTodayPillTaken,
    required this.onTakePill,
    required this.undoTakePill,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = totalPills > 0 ? currentPillNumberInCycle / totalPills : 0.0;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

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
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isTodayPillTaken ? undoTakePill : onTakePill,
              icon: Icon(isTodayPillTaken ? Icons.undo : Icons.medical_services_rounded),
              label: Text(
                isTodayPillTaken ? l10n.pillStatus_undo : l10n.pillStatus_markAsTaken,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: isTodayPillTaken
                    ? Colors.grey[600]
                    : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}