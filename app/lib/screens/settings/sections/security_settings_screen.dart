import 'package:flutter/material.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  bool _isLoading = true;
  bool _isDeviceSupported = false;

  @override
  void initState() {
    super.initState();
    _checkDeviceSupport();
  }

  Future<void> _checkDeviceSupport() async {
    final bool isSupported = await _localAuth.isDeviceSupported();

    if (mounted) {
      setState(() {
        _isDeviceSupported = isSupported;
        _isLoading = false;
      });
    }
  }

  Future<void> _onToggleChanged(bool value) async {
    if (value && !_isDeviceSupported) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.securityScreen_noBiometricsAvailable),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    context.read<SettingsService>().setBiometricsEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();
    final bool isBiometricEnabled = settingsService.areBiometricsEnabled;
    
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
                  value: isBiometricEnabled,
                  onChanged: _isDeviceSupported ? _onToggleChanged : null,
                ),
              ],
            ),
    );
  }
}