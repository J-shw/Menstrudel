import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/sex_repository.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/widgets/sex_activities/sheets/log_sex_activity_bottom_sheet.dart';
import 'package:menstrudel/widgets/sex_activities/sheets/sex_activity_details_bottom_sheet.dart';

class LogSexUIController extends ChangeNotifier {
  final SexRepository _repo = SexRepository();

  /// Handles creating a new sex activity log
  Future<void> handleCreateNewSexLog({
    required BuildContext context,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return LogSexActivityBottomSheet(
          onSave: (dateTime, sexType, participationType, protectionType, note) async {
            final newEntry = SexLogEntry(
              id: null,
              dateTime: dateTime,
              sexType: sexType,
              participationType: participationType,
              protectionType: protectionType,
              note: note,
            );

            await _repo.logActivity(newEntry);
            if (!sheetContext.mounted) return;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Handles editing or deleting an existing sex log
  Future<void> handleEditSexLog({
    required BuildContext context,
    required SexLogEntry entry,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return EditSexLogBottomSheet(
          log: entry,
          onSave: (updatedEntry) async {
            await _repo.updateLog(updatedEntry);
            if (!sheetContext.mounted) return;
            Navigator.pop(context);
            notifyListeners();
          },
          onDelete: () async {
            if (entry.id != null) {
              await _repo.deleteLog(entry.id!);
              if (!sheetContext.mounted) return;
              Navigator.pop(context);
              notifyListeners();
            }
          },
        );
      },
    );
  }
}