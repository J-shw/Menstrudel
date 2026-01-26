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
    final l10n = AppLocalizations.of(context)!;
    final RenderBox box = context.findRenderObject() as RenderBox;
    SharePlus.instance.share(
      ShareParams(text: '${l10n.aboutScreen_shareText} https://menstrudel.app/', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,)
    );
  }

  @override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  return Scaffold(
    appBar: AppBar(title: Text(l10n.settingsScreen_about), centerTitle: true),
    body: ListView(
      children: [
        const SizedBox(height: 32),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/icon/menstrudel.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            "Menstrudel", 
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Center(child: Text("${l10n.aboutScreen_version} $_appVersion", style: theme.textTheme.bodySmall)),
        const SizedBox(height: 32),

        _buildSectionHeader(context, l10n.aboutScreen_communityAndUpdates),
        _buildListTile(
          icon: Icons.history_rounded,
          title: "Release Notes",
          subtitle: l10n.aboutScreen_releaseNotesSubtitle(_appVersion),
          onTap: () => _launchUrl('https://menstrudel.app/release-notes/', l10n),
        ),
        _buildListTile(
          icon: Icons.discord,
          title: l10n.aboutScreen_discord,
          subtitle: l10n.aboutScreen_discordSubtitle,
          onTap: () => _launchUrl('https://discord.gg/H95kG7zPWB', l10n),
        ),

        const Divider(),
        _buildSectionHeader(context, l10n.aboutScreen_legalAndSource),
        _buildListTile(
          icon: Icons.privacy_tip_outlined,
          title: l10n.aboutScreen_privacyPolicy,
          subtitle: l10n.aboutScreen_privacyPolicySubtitle,
          onTap: () => _launchUrl('https://github.com/J-shw/Menstrudel/blob/main/PRIVACY.md', l10n),
        ),
        _buildListTile(
          icon: Icons.code_rounded,
          title: l10n.aboutScreen_github,
          subtitle: l10n.aboutScreen_githubSubtitle,
          onTap: () => _launchUrl('https://github.com/J-shw/Menstrudel', l10n),
        ),
        
        const SizedBox(height: 40),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: OutlinedButton.icon(
            onPressed: _shareWebsite,
            icon: const Icon(Icons.share_rounded, size: 18),
            label: Text(l10n.aboutScreen_share),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionHeader(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
    child: Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildListTile({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle != null ? Text(subtitle) : null,
    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    onTap: onTap,
  );
}
}