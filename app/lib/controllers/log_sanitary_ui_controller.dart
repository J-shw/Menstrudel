import 'package:flutter/material.dart';
import 'package:menstrudel/database/repositories/sanitary_product_repository.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/widgets/sanitary_products/sheets/log_sanitary_product_bottom_sheet.dart';
import 'package:menstrudel/widgets/sanitary_products/sheets/edit_sanitary_product_bottom_sheet.dart';

class LogSanitaryUIController extends ChangeNotifier {
  final SanitaryProductRepository _repo = SanitaryProductRepository();

  /// Handles creating a new sanitary log entry
  Future<void> handleCreateNewSanitaryLog({
    required BuildContext context,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return LogSanitaryProductBottomSheet(
          onSave: (logTime, note, type, reminderEndTime) async {
            final newEntry = SanitaryProductsEntry(
              id: null,
              logTime: logTime,
              reminderTime: reminderEndTime,
              type: type,
              note: note,
            );

            await _repo.logSanitaryProduct(newEntry);
            if (!sheetContext.mounted) return;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Handles editing or deleting an existing sanitary log entry
  Future<void> handleEditSanitaryLog({
    required BuildContext context,
    required SanitaryProductsEntry entry,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return EditSanitaryProductBottomSheet(
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