import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart'; 
import 'package:menstrudel/services/notification_service.dart';

class DataSettingsScreen extends StatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  State<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends State<DataSettingsScreen> {
  final periodsRepo = PeriodsRepository();
  final pillsRepo = PillsRepository();
  bool _isLoading = false;

  Future<void> clearPeriodLogs() async {
    setState(() { _isLoading = true; });
    await periodsRepo.manager.clearAllData();
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsScreen_allLogsHaveBeenCleared)),
    );
    setState(() { _isLoading = false; });
  }

  Future<void> showClearPeriodLogsDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_clearAllLogs_question,
          contentText: l10n.settingsScreen_deleteAllLogsDescription,
          confirmButtonText: l10n.clear,
          onConfirm: clearPeriodLogs,
        );
      },
    );
  }

  Future<void> clearPillData() async {
    setState(() { _isLoading = true; });
    
    await pillsRepo.deleteAllEntries();
    await NotificationService.cancelPillReminder();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsScreen_allPillDataCleared)),
    );
    setState(() { _isLoading = false; });
  }
  
  Future<void> showClearPillDataDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: l10n.settingsScreen_clearAllPillData_question,
          contentText: l10n.settingsScreen_deleteAllPillDataDescription,
          confirmButtonText: l10n.clear,
          onConfirm: clearPillData,
        );
      },
    );
  }


  @override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.settingsScreen_dataManagement),
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              color: colorScheme.errorContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                    title: Text(
                      l10n.settingsScreen_dangerZone,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Divider(height: 1, color: colorScheme.onErrorContainer.withValues(alpha:0.3)),

                  ListTile(
                    title: Text(
                      l10n.settingsScreen_clearAllLogs,
                      style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onErrorContainer),
                    ),
                    subtitle: Text(
                      l10n.settingsScreen_clearAllLogsSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer.withValues(alpha:0.8)),
                    ),
                    // Trailing icon makes it look tappable
                    trailing: Icon(Icons.chevron_right, color: colorScheme.onErrorContainer),
                    onTap: showClearPeriodLogsDialog,
                  ),

                  ListTile(
                    title: Text(
                      l10n.settingsScreen_clearAllPillData,
                      style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onErrorContainer),
                    ),
                    subtitle: Text(
                      l10n.settingsScreen_clearAllPillDataSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer.withValues(alpha:0.8)),
                    ),
                    trailing: Icon(Icons.chevron_right, color: colorScheme.onErrorContainer),
                    onTap: showClearPillDataDialog,
                  ),
                ],
              ),
            ),
          ),
  );
}
}