import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:provider/provider.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.watch<SettingsService>();

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.book),
          icon: Icon(Icons.book_outlined),
          label: l10n.navBar_logs,
        ),
        if (settingsService.isSanitaryNavEnabled)
          NavigationDestination(
            selectedIcon: Icon(Icons.water_drop_rounded),
            icon: Icon(Icons.water_drop_outlined),
            label: l10n.navBar_sanitary,
          ),
        if (settingsService.isSexActivityNavEnabled)
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_rounded),
            icon: Icon(Icons.favorite_border_rounded),
            label: l10n.navBar_sexActivity,
          ),
        if (settingsService.isPillNavEnabled)
          NavigationDestination(
            selectedIcon: Icon(Icons.medication_rounded),
            icon: Icon(Icons.medication_outlined),
            label: l10n.navBar_pill,
          ),
        if (settingsService.isReversibleContraceptiveNavEnabled)
          NavigationDestination(
            selectedIcon: Icon(Icons.verified_user_rounded),
            icon: Icon(Icons.verified_user_outlined),
            label: l10n.navBar_reversibleContraceptive,
          ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: l10n.navBar_settings,
        ),
      ],
    );
  }
}