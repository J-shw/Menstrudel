import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/reversible_contraceptive_repository.dart';
import 'package:menstrudel/models/birth_control/reversible_contraceptives/reversible_contraceptive_log_entry.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:menstrudel/screens/dashboards/reversible_contraceptive/widgets/edit_reversible_contraceptive_bottom_sheet.dart';
import 'package:menstrudel/screens/dashboards/reversible_contraceptive/widgets/reversible_contraceptive_bottom_sheet.dart';
import 'package:provider/provider.dart';

class LogReversibleContraceptiveUIController extends ChangeNotifier {
  final ReversibleContraceptiveRepository _repo = ReversibleContraceptiveRepository();

  /// Handles creating a new Reversible Contraceptive log entry
  Future<void> handleCreateNewReversibleContraceptiveLog({
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
        return LogReversibleContraceptiveBottomSheet(
          onSave: (date, note) async {
            final newEntry = ReversibleContraceptiveLogEntry(
              id: null,
              date: date,
              type: settingsService.reversibleContraceptiveType,
              note: note,
            );

            await _repo.log(newEntry);
            if (!sheetContext.mounted) return;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Handles editing or deleting an existing ReversibleContraceptive log
  Future<void> handleEditReversibleContraceptiveLog({
    required BuildContext context,
    required ReversibleContraceptiveLogEntry entry,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return EditReversibleContraceptiveLogBottomSheet(
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