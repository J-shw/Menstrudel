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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Pill $currentPillNumberInCycle of $totalPills',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isTodayPillTaken ? 'Taken for today' : 'Ready to take',
              style: TextStyle(
                fontSize: 16,
                color: isTodayPillTaken ? Colors.green : Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
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
                  disabledBackgroundColor: Colors.green.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}