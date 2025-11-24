import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';

typedef SanitaryProductSaveCallback = void Function(TimeOfDay time, String? note, SanitaryProducts type);

class LogSanitaryProductBottomSheet extends StatefulWidget {
  final SanitaryProductSaveCallback onSave;

  const LogSanitaryProductBottomSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<LogSanitaryProductBottomSheet> createState() => _LogSanitaryProductBottomSheetState();
}

class _LogSanitaryProductBottomSheetState extends State<LogSanitaryProductBottomSheet> {
  final _noteController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final SanitaryProducts _type = SanitaryProducts.tampon;

    @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _handleSave() {
    final String? noteToSave = _noteController.text.trim().isEmpty
    ? null 
    : _noteController.text.trim();
    widget.onSave(_selectedTime, noteToSave, _type);
    Navigator.pop(context);
  }
  
  void _handleCancel() {
    Navigator.pop(context); 
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Drag Handle ---
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 12),
            
            // --- Title ---
            Center(child: Text(l10n.larcEntrySheet_logLARCDetails, style: textTheme.titleLarge)),
            
            // --- Date Picker ---
            const SizedBox(height: 24),
            Text(l10n.date, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(_selectedTime.format(context)),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), alignment: Alignment.centerLeft),
              onPressed: _selectTime,
            ),

            // --- Text Note ---
            const SizedBox(height: 8),
            Text(l10n.note, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
                controller: _noteController,
                autofocus: false,
                maxLength: 500,
                maxLines: 3,
              ),

            const SizedBox(height: 24),

            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: _handleCancel,
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: _handleSave,
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}