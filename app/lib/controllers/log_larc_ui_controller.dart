import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/larc_repository.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/widgets/larcs/sheets/edit_larc_bottom_sheet.dart';
import 'package:menstrudel/widgets/larcs/sheets/log_larc_bottom_sheet.dart';
import 'package:provider/provider.dart';

class LogLarcUIController extends ChangeNotifier {
  final LarcRepository _repo = LarcRepository();

  /// Handles creating a new LARC log entry
  Future<void> handleCreateNewLarcLog({
    required BuildContext context,
  }) async {
    final settingsService = context.read<SettingsService>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return LogLarcBottomSheet(
          onSave: (date, note) async {
            final newEntry = LarcLogEntry(
              id: null,
              date: date,
              type: settingsService.larcType,
              note: note,
            );

            await _repo.logLarc(newEntry);
            if (!sheetContext.mounted) return;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Handles editing or deleting an existing LARC log
  Future<void> handleEditLarcLog({
    required BuildContext context,
    required LarcLogEntry entry,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return EditLarcLogBottomSheet(
          log: entry,
          onSave: (updatedEntry) async {
            await _repo.updateLog(updatedEntry);
            if (!sheetContext.mounted) return;
            notifyListeners();
          },
          onDelete: () async {
            if (entry.id != null) {
              await _repo.deleteLog(entry.id!);
              if (!sheetContext.mounted) return;
              notifyListeners();
            }
          },
        );
      },
    );
  }
}