import 'package:flutter/material.dart';
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
  TimeOfDay _startTime = TimeOfDay.now();
  SanitaryProducts _selectedType = SanitaryProducts.tampon;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
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
        _startTime = pickedTime;
      });
    }
  }

  void _handleSave() {
    final String? noteToSave = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();
    
    widget.onSave(_startTime, noteToSave, _selectedType);
    Navigator.pop(context);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  DateTime _getEstimatedEndTime() {
    final now = DateTime.now();
    final startDateTime = DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute);
    return startDateTime.add(Duration(hours: _selectedType.defaultDurationHours));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final endTime = TimeOfDay.fromDateTime(_getEstimatedEndTime());
    final durationText = '${_selectedType.defaultDurationHours}h';

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
            Center(child: Text(l10n.sanitaryEntrySheet_logSanitaryProduct, style: textTheme.titleLarge)),
            
            const SizedBox(height: 24),

            // --- Type Selector ---
            Text(l10n.type, style: textTheme.bodySmall),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SanitaryProducts.values.map((type) {
                  final isSelected = _selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(type.getDisplayName(l10n)),
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            _selectedType = type;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // --- Date/Time Selection Display ---
            const SizedBox(height: 24),
            Text(l10n.time, style: textTheme.bodySmall),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectTime,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.start, style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary)),
                          const SizedBox(height: 4),
                          Text(_startTime.format(context), style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Icon(Icons.arrow_forward, color: colorScheme.outline),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Text(durationText, style: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.end, style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary)),
                        const SizedBox(height: 4),
                        Text(endTime.format(context), style: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- Text Note ---
            const SizedBox(height: 24),
            Text(l10n.note, style: textTheme.bodySmall),
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