import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const SizedBox.shrink();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/menstrudel.png', 
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingScreen_welcomeToMenstrudel,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              l10n.onboardingScreen_welcomeToMenstrudelDescription,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}