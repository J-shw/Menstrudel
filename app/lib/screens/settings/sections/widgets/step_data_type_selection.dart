import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/app/data_settings_type_enum.dart';
import 'data_menu_card.dart';

class StepDataTypeSelection extends StatelessWidget {
  final String title;
  final Function(DataType) onTypeSelected;

  const StepDataTypeSelection({
    super.key,
    required this.title,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_logsAndPeriods,
          icon: Icons.book,
          onTap: () => onTypeSelected(DataType.logsAndPeriods),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_pillLogs,
          icon: Icons.medication_rounded,
          onTap: () => onTypeSelected(DataType.pills),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_sanitaryProductLogs,
          icon: Icons.water_drop_rounded,
          onTap: () => onTypeSelected(DataType.sanitaryProducts),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_reversibleContraceptivesLogs,
          icon: Icons.verified_user_rounded,
          onTap: () => onTypeSelected(DataType.reversibleContraceptives),
        ),
        DataMenuCard(
          title: l10n.settingsScreen_sexualActivityLogs, 
          icon: Icons.favorite_rounded,
          onTap: () => onTypeSelected(DataType.sexualActivity),
        ),
      ],
    );
  }
}