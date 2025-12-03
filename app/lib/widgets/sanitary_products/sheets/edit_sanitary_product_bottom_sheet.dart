import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';

typedef SanitaryUpdateCallback = void Function(SanitaryProductsEntry updatedEntry);

class EditSanitaryProductBottomSheet extends StatefulWidget {
  final SanitaryProductsEntry log;
  final SanitaryUpdateCallback onSave;
  final VoidCallback onDelete;

  const EditSanitaryProductBottomSheet({
    super.key,
    required this.log,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditSanitaryProductBottomSheet> createState() => _EditSanitaryProductBottomSheetState();
}

class _EditSanitaryProductBottomSheetState extends State<EditSanitaryProductBottomSheet> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _noteController;
  late SanitaryProducts _selectedType;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.log.logTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.log.logTime);
    _selectedType = widget.log.type;
    _noteController = TextEditingController(text: widget.log.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final String? noteToSave = _noteController.text.trim().isEmpty
        ? null 
        : _noteController.text.trim();

    final newLogTime = DateTime(
      _selectedDate.year, 
      _selectedDate.month, 
      _selectedDate.day,
      _selectedTime.hour, 
      _selectedTime.minute
    );

    final updatedEntry = widget.log.copyWith(
      logTime: newLogTime,
      note: noteToSave,
      type: _selectedType,
    );
    widget.onSave(updatedEntry);

    setState(() {
      _isEditing = false;
    });
  }

  void _resetEditableState() {
    setState(() {
      _selectedDate = widget.log.logTime;
      _selectedTime = TimeOfDay.fromDateTime(widget.log.logTime);
      _selectedType = widget.log.type;
      _noteController.text = widget.log.note ?? '';
    });
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && mounted) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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
            
            // --- Header ---
            _buildHeader(context, textTheme, colorScheme, l10n),
            const SizedBox(height: 24),

            // --- Type Display/Edit ---
             if (_isEditing) ...[
                Text(l10n.type, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SanitaryProducts.values.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: _selectedType == type,
                          label: Text(type.getDisplayName(l10n)),
                          onSelected: (bool selected) {
                            if (selected) setState(() => _selectedType = type);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
            ] else ...[
               Row(
                 children: [
                   Icon(_selectedType.getIcon(), color: colorScheme.primary),
                   const SizedBox(width: 8),
                   Text(_selectedType.getDisplayName(l10n), style: textTheme.titleMedium),
                 ],
               ),
               const SizedBox(height: 24),
            ],
            
            // --- Date & Time ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.date, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(DateFormat('EEE, d MMM').format(_selectedDate)),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), alignment: Alignment.centerLeft),
                        onPressed: _isEditing ? _selectDate : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.time, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(_selectedTime.format(context)),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), alignment: Alignment.centerLeft),
                        onPressed: _isEditing ? _selectTime : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // --- Text Note ---
            const SizedBox(height: 16),
            Text(l10n.note, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            TextFormField(
                controller: _noteController,
                readOnly: !_isEditing,
                autofocus: false,
                maxLength: 500,
                maxLines: 3,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, TextTheme textTheme, ColorScheme colorScheme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.sanitaryEntrySheet_logSanitaryProduct,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        
        if (_isEditing)
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _resetEditableState();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.check, color: colorScheme.primary),
                onPressed: _handleSave,
              ),
            ],
          )
        else
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 24, color: colorScheme.error),
                onPressed: widget.onDelete,
              ),
            ],
          ),
      ],
    );
  }
}