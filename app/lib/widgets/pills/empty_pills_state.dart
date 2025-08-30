import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class EmptyPillsState extends StatelessWidget {
  const EmptyPillsState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medication_liquid_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.emptyPillStateWidget_noPillRegimenFound, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              l10n.emptyPillStateWidget_noPillRegimenFoundDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}