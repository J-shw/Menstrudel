import 'package:flutter/material.dart';
import 'package:menstrudel/coordinators/data_refresh_coordinator.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/database/repositories/sex_repository.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/app/data_settings_type_enum.dart';
import 'package:menstrudel/widgets/dialogs/delete_confirmation_dialog.dart';
import 'package:menstrudel/database/repositories/pills_repository.dart';
import 'package:menstrudel/database/repositories/reversible_contraceptive_repository.dart';
import 'package:menstrudel/database/repositories/sanitary_product_repository.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'widgets/step_action_selection.dart';
import 'widgets/step_data_type_selection.dart';

enum DataAction { export, import, delete }

class DataSettingsScreen extends StatefulWidget {
  const DataSettingsScreen({super.key});

  @override
  State<DataSettingsScreen> createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends State<DataSettingsScreen> {
  DataAction? _selectedAction;
  bool _isLoading = false;

  final periodsRepo = PeriodsRepository();
  final pillsRepo = PillsRepository();
  final reversibleContraceptiveRepo = ReversibleContraceptiveRepository();
  final sanitaryRepo = SanitaryProductRepository();
  final sexRepo = SexRepository();

  Future<void> _handleDataTask(DataType type) async {
    switch (_selectedAction) {
      case DataAction.export:
        _exportLogic(type);
        break;
      case DataAction.import:
        _importLogic(type);
        break;
      case DataAction.delete:
        _deleteLogic(type);
        break;
      default:
        break;
    }
  }

  // --- Export Logic ---

  Future<void> _exportLogic(DataType type) async {
    switch (type) {
      case DataType.logsAndPeriods:
        await _performExport(
          () => periodsRepo.manager.exportDataAsJson(),
          type.fileName(),
        );
      case DataType.pills:
        await _performExport(
          () => pillsRepo.manager.exportDataAsJson(),
          type.fileName(),
        );
      case DataType.reversibleContraceptives:
        await _performExport(
          () => reversibleContraceptiveRepo.manager.exportDataAsJson(),
          type.fileName(),
        );
      case DataType.sanitaryProducts:
        await _performExport(
          () => sanitaryRepo.manager.exportDataAsJson(),
          type.fileName(),
        );
      case DataType.sexualActivity:
        await _performExport(
          () => sexRepo.manager.exportDataAsJson(),
          type.fileName(),
        );
    }
  }

  Future<void> _performExport(
    Future<String> Function() dataSource,
    String fileNamePart,
  ) async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;
    String filePath = '';

    try {
      final jsonData = await dataSource();
      if (jsonData.isEmpty) throw Exception();

      final Directory directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'menstrudel_${fileNamePart}_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonData);
      filePath = file.path;

      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox;
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        ),
      );

      if (result.status == ShareResultStatus.success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_exportSuccessful)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_exportFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
      if (filePath.isNotEmpty) {
        await File(filePath).delete().catchError((_) => null);
      }
    }
  }

  // --- Import Logic ---

  Future<void> _importLogic(DataType type) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'])
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('File picking timed out.');
            },
          );
      if (result == null || result.files.single.path == null || !mounted)
        return;

      final path = result.files.single.path!;

      showDialog(
        context: context,
        builder: (ctx) => ConfirmationDialog(
          title: l10n.import,
          contentText: l10n.settingsScreen_importDataSubtitle,
          confirmButtonText: l10n.import,
          onConfirm: () => _performImport(path, type),
        ),
      );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_importErrorGeneral)),
        );
    }
  }

  Future<void> _performImport(String path, DataType type) async {
    setState(() => _isLoading = true);
    final coordinator = context.read<DataRefreshCoordinator>();
    final l10n = AppLocalizations.of(context)!;
    try {
      final content = await File(path).readAsString();
      switch (type) {
        case DataType.logsAndPeriods:
          await periodsRepo.manager.importDataFromJson(content);
        case DataType.pills:
          await pillsRepo.manager.importDataFromJson(content, l10n);
        case DataType.reversibleContraceptives:
          await reversibleContraceptiveRepo.manager.importDataFromJson(content);
        case DataType.sanitaryProducts:
          await sanitaryRepo.manager.importDataFromJson(content);
        case DataType.sexualActivity:
          await sexRepo.manager.importDataFromJson(content);
      }
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_importSuccessful)),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsScreen_importFailed)),
        );
    } finally {
      if (type == DataType.logsAndPeriods) {
        await coordinator.resetAllData();
      }
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Delete Logic ---

  void _deleteLogic(DataType type) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: type.clearTitle(l10n),
        contentText: type.clearSubtitle(l10n),
        confirmButtonText: l10n.clear,
        onConfirm: () => _performClear(type),
      ),
    );
  }

  Future<void> _performClear(DataType type) async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;
    final coordinator = context.read<DataRefreshCoordinator>();

    switch (type) {
      case DataType.logsAndPeriods:
        await periodsRepo.manager.clearAllData();
        await coordinator.resetAllData();
      case DataType.pills:
        await pillsRepo.manager.clearAllData();
        await NotificationService.cancelPillReminder();
      case DataType.reversibleContraceptives:
        await reversibleContraceptiveRepo.manager.clearAllData();
        await NotificationService.cancelReversibleContraceptiveReminder();
      case DataType.sanitaryProducts:
        await sanitaryRepo.manager.clearAllData();
        await NotificationService.cancelSanitaryProductReminder();
      case DataType.sexualActivity:
        await sexRepo.manager.clearAllData();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsScreen_allLogsHaveBeenCleared)),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreen_dataManagement),
        leading: _selectedAction != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedAction = null),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _selectedAction == null
                  ? StepActionSelection(
                      onActionSelected: (a) =>
                          setState(() => _selectedAction = a),
                    )
                  : Column(
                      children: [
                        if (_selectedAction == DataAction.import)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.settingsScreen_importSupportNote,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: StepDataTypeSelection(
                            title: switch (_selectedAction) {
                              DataAction.import =>
                                l10n.settingsScreen_importDataTitle,
                              DataAction.export =>
                                l10n.settingsScreen_exportDataTitle,
                              DataAction.delete =>
                                l10n.settingsScreen_deleteZone,
                              _ => '',
                            },
                            onTypeSelected: _handleDataTask,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
