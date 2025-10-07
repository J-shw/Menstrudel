import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart'; 
import 'package:menstrudel/services/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'dart:io';

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
    
    await pillsRepo.manager.clearAllData();
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

  Future<void> exportPeriodData() async {
    setState(() { _isLoading = true; });

    final l10n = AppLocalizations.of(context)!;
    String filePath = '';


    try {
      final jsonData = await periodsRepo.manager.exportDataAsJson();
      
      if (jsonData.isEmpty) {
        throw Exception(l10n.settingsScreen_noDataToExport);
      }

      final Directory directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'menstrudel_data_$timestamp.json';
      final exportFile = File('${directory.path}/$fileName');

      await exportFile.writeAsString(jsonData);
      filePath = exportFile.path;

      final params = ShareParams(
        text: l10n.settingsScreen_exportDataMessage,
        files: [XFile(filePath)],
      );

      final result = await SharePlus.instance.share(params);
      if (result.status == ShareResultStatus.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_exportSuccessful)),
        );
      }

    } catch (e) {
      debugPrint('Export failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_exportFailed)),
        );
      }
    } finally {
      if (mounted){
        setState(() { _isLoading = false; });
        if (filePath.isNotEmpty) {
          try {
            await File(filePath).delete();
          } catch (e) {
            debugPrint('Failed to delete temporary file: $e');
          }
        }
      }
    }
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
        : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                const SizedBox(height: 24),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.download, color: theme.primaryColor),
                        title: Text(
                          l10n.settingsScreen_exportData,
                          style: theme.textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          l10n.settingsScreen_exportDataSubtitle,
                          style: theme.textTheme.bodyMedium,
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: exportPeriodData,
                      ),
                    ],
                  ),
                ),
              ],
            ),
  );
}
}