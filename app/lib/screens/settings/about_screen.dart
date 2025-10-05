import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
      });
    }
  }

  Future<void> _launchUrl(String url, AppLocalizations l10n) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.aboutScreen_urlError)),
        );
      }
    }
  }
  
  void _shareWebsite() {
    SharePlus.instance.share(
      ShareParams(text: 'Your cycle, your data. Check out Menstrudel, the free and private period tracker: https://menstrudel.app/')
    );
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.aboutScreen_version),
                subtitle: Text(_appVersion),
              ),

              const Divider(height: 1, indent: 16, endIndent: 16),

              ListTile(
                leading: const Icon(Icons.code_rounded),
                title: Text(l10n.aboutScreen_github),
                subtitle: Text(l10n.aboutScreen_githubSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _launchUrl('https://github.com/J-shw/Menstrudel', l10n);
                },
              ),

              const Divider(height: 1, indent: 16, endIndent: 16),

              ListTile(
                leading: const Icon(Icons.share_rounded),
                title: Text(l10n.aboutScreen_share),
                subtitle: Text(l10n.aboutScreen_shareSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: _shareWebsite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}