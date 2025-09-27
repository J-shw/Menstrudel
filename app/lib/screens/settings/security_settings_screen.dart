import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _isLoading = true;
  bool _isBiometricEnabled = false;
  bool _isDeviceSupported = false;

  @override
  void initState() {
    super.initState();
    _loadSettingsAndCheckSupport();
  }

  Future<void> _loadSettingsAndCheckSupport() async {
    final responses = await Future.wait([
      _settingsService.areBiometricsEnabled(),
      _localAuth.isDeviceSupported(),
    ]);

    if (mounted) {
      setState(() {
        _isBiometricEnabled = responses[0];
        _isDeviceSupported = responses[1];
        _isLoading = false;
      });
    }
  }

  Future<void> _onToggleChanged(bool value) async {
    if (value) {
      final bool isSupported = await _localAuth.isDeviceSupported();
      if (!isSupported) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.securityScreen_noBiometricsAvailable),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
    }

    setState(() {
      _isBiometricEnabled = value;
    });
    _settingsService.setBiometricsEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_security),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: Text(l10n.securityScreen_enableBiometricLock),
                  subtitle: Text(l10n.securityScreen_enableBiometricLockSubtitle),
                  secondary: const Icon(Icons.fingerprint),
                  value: _isBiometricEnabled,
                  onChanged: _isDeviceSupported ? _onToggleChanged : null,
                ),
              ],
            ),
    );
  }
}