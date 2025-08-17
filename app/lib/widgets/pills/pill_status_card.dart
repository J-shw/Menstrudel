import 'package:flutter/material.dart';

class PillStatusCard extends StatelessWidget {
  final int currentPillNumberInCycle;
  final int totalPills;
  final bool isTodayPillTaken;
  final VoidCallback onTakePill;

  const PillStatusCard({
    super.key,
    required this.currentPillNumberInCycle,
    required this.totalPills,
    required this.isTodayPillTaken,
    required this.onTakePill,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = totalPills > 0 ? currentPillNumberInCycle / totalPills : 0.0;
    final Color primaryColor = Theme.of(context).colorScheme.primary;

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
                      'of $totalPills pills',
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
              onPressed: isTodayPillTaken ? null : onTakePill,
              icon: Icon(isTodayPillTaken ? Icons.check_circle : Icons.medical_services_rounded),
              label: Text(
                isTodayPillTaken ? 'All Set!' : 'Mark as Taken',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                disabledBackgroundColor: Colors.green.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}