import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/screens/settings/sections/data_settings_screen.dart';
import 'data_menu_card.dart';

class StepActionSelection extends StatelessWidget {
  final Function(DataAction) onActionSelected;

  const StepActionSelection({super.key, required this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DataMenuCard(
          title: l10n.settingsScreen_exportDataTitle,
          icon: Icons.upload_rounded,
          color: colorScheme.primary,
          onTap: () => onActionSelected(DataAction.export),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_importDataTitle,
          icon: Icons.download_rounded,
          color: colorScheme.secondary,
          onTap: () => onActionSelected(DataAction.import),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_deleteZone,
          icon: Icons.delete_forever_rounded,
          color: colorScheme.error,
          onTap: () => onActionSelected(DataAction.delete),
        ),
      ],
    );
  }
}