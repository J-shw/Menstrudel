import 'package:flutter/material.dart';
import 'package:menstrudel/screens/gates/auth_gate.dart';
import 'package:menstrudel/screens/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/user_repository.dart';
import 'package:menstrudel/models/app/user_entry.dart';

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = context.read<UserRepository>();

    return FutureBuilder<UserEntry?>(
      future: userRepo.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.data == null) {
          return const OnboardingScreen();
        }

        return const AuthGate(); 
      },
    );
  }
}