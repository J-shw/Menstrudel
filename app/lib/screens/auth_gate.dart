import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:menstrudel/screens/main_screen.dart';
import 'package:menstrudel/services/settings_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatusAndProceed();
  }

  Future<void> _checkAuthStatusAndProceed() async {
    final bool isEnabled = await _settingsService.areBiometricsEnabled();

    if (!isEnabled) {
      _navigateToMainScreen();
      return;
    }

    _authenticate();
  }

  void _navigateToMainScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  Future<void> _authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();
  try {
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to open Menstrudel',
      persistAcrossBackgrounding: true, 
      biometricOnly: false, 
    );

    if (didAuthenticate) {
      _navigateToMainScreen();
    } else {
      SystemNavigator.pop();
    }
  } catch (e) {
    debugPrint('Error during authentication: $e');
    SystemNavigator.pop();
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}