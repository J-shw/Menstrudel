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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:async';

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
      final fileName = 'menstrudel_period_data_$timestamp.json';
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

  Future<void> exportPillData() async {
    setState(() { _isLoading = true; });

    final l10n = AppLocalizations.of(context)!;
    String filePath = '';


    try {
      final jsonData = await pillsRepo.manager.exportDataAsJson();
      
      if (jsonData.isEmpty) {
        throw Exception(l10n.settingsScreen_noDataToExport);
      }

      final Directory directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'menstrudel_pill_data_$timestamp.json';
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

  Future<void> _importData(String filePath, {required bool isPillData}) async {
    setState(() { _isLoading = true; });

    final l10n = AppLocalizations.of(context)!;

    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();

      if (isPillData) {
        await pillsRepo.manager.importDataFromJson(jsonString, l10n);
      } else {
        await periodsRepo.manager.importDataFromJson(jsonString);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsScreen_importSuccessful)),
      );
    } on FormatException catch (e) {
      debugPrint('Import failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_importInvalidFile)),
        );
      }
    } catch (e) {
      debugPrint('Import failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_importFailed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> importPeriodData() async {
    final l10n = AppLocalizations.of(context)!;
    try{
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('File picking timed out.');
        },
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        
        if (!mounted) return;
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              title: l10n.settingsScreen_importPeriodData_question,
              contentText: l10n.settingsScreen_importPeriodDataDescription,
              confirmButtonText: l10n.import,
              onConfirm: () => _importData(filePath, isPillData: false),
            );
          },
        );
      }
    }on PlatformException catch (e) {
    debugPrint("File picker platform error: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsScreen_importErrorPlatform(e.message ?? 'An unknown error occurred.')),
        ),
      );
    }
  } catch (e) {
    debugPrint("General file picker error: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.settingsScreen_importErrorGeneral),
        ),
      );
    }
  }
  }

  Future<void> importPillData() async {
    final l10n = AppLocalizations.of(context)!;
    try {

      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('File picking timed out.');
        },
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        
        if (!mounted) return;
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              title: l10n.settingsScreen_importPillData_question,
              contentText: l10n.settingsScreen_importPillDataDescription,
              confirmButtonText: l10n.import,
              onConfirm: () => _importData(filePath, isPillData: true),
            );
          },
        );
      }
    } on PlatformException catch (e) {
      debugPrint("File picker platform error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsScreen_importErrorPlatform(e.message ?? 'An unknown error occurred.')),
          ),
        );
      }
    } catch (e) {
      debugPrint("General file picker error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsScreen_importErrorGeneral),
          ),
        );
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                        
                        Divider(height: 1, color: colorScheme.onErrorContainer.withValues(alpha: 0.3)),

                        ListTile(
                          title: Text(
                            l10n.settingsScreen_clearAllLogs,
                            style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onErrorContainer),
                          ),
                          subtitle: Text(
                            l10n.settingsScreen_clearAllLogsSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer.withValues(alpha: 0.8)),
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
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onErrorContainer.withValues(alpha: 0.8)),
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
                          leading: Icon(Icons.download_rounded, color: colorScheme.primary),
                          title: Text(
                            l10n.settingsScreen_exportDataTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        Divider(height: 1, color: colorScheme.onErrorContainer.withValues(alpha: 0.3)),

                        ListTile(
                          title: Text(
                            l10n.settingsScreen_exportPeriodData,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            l10n.settingsScreen_exportDataSubtitle,
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: exportPeriodData,
                        ),

                        ListTile(
                          title: Text(
                            l10n.settingsScreen_exportPillData,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            l10n.settingsScreen_exportDataSubtitle,
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: exportPillData,
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
                          leading: Icon(Icons.upload_rounded, color: colorScheme.primary),
                          title: Text(
                            l10n.settingsScreen_importDataTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Divider(height: 1, color: colorScheme.onErrorContainer.withValues(alpha: 0.3)),

                        ListTile(
                          title: Text(
                            l10n.settingsScreen_importPeriodData,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            l10n.settingsScreen_importDataSubtitle,
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: importPeriodData,
                        ),
                        
                        ListTile(
                          title: Text(
                            l10n.settingsScreen_importPillData,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            l10n.settingsScreen_importDataSubtitle,
                            style: theme.textTheme.bodyMedium,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: importPillData,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          )
    );
  }
}