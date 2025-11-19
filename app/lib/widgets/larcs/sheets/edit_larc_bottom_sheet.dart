import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/birth_control/larcs/larc_log_entry.dart';

typedef LarcUpdateCallback = void Function(LarcLogEntry updatedEntry);

class EditLarcLogBottomSheet extends StatefulWidget {
  final LarcLogEntry log;
  final LarcUpdateCallback onSave;
  final VoidCallback onDelete;

  const EditLarcLogBottomSheet({
    super.key,
    required this.log,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditLarcLogBottomSheet> createState() => _EditLarcLogBottomSheetState();
}

class _EditLarcLogBottomSheetState extends State<EditLarcLogBottomSheet> {
  late DateTime _selectedDate;
  late TextEditingController _noteController;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.log.date;
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

    final updatedEntry = widget.log.copyWith(
      date: _selectedDate,
      note: noteToSave,
    );
    widget.onSave(updatedEntry);

    setState(() {
      _isEditing = false;
    });
  }

  void _resetEditableState() {
    setState(() {
      _selectedDate = widget.log.date;
      _noteController.text = widget.log.note ?? '';
    });
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
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
            _buildHeader(context, textTheme, colorScheme),
            
            // --- Date Picker ---
            const SizedBox(height: 24),
            Text(l10n.date, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(DateFormat('EEEE, d MMMM yyyy').format(_selectedDate)),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), alignment: Alignment.centerLeft),
              onPressed: _isEditing ? _selectDate : null,
            ),

            // --- Text Note ---
            const SizedBox(height: 8),
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
  
  Widget _buildHeader(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LARC Log Details', 
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