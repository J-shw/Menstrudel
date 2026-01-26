import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_participation_type_enum.dart';
import 'package:menstrudel/models/sex/sex_protection_type_enum.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';

typedef SexActivitySaveCallback = void Function(
  DateTime date, 
  SexTypes? sexType, 
  SexParticipationTypes? participationType, 
  SexProtectionTypes? protectionType, 
  String? note
);

class LogSexActivityBottomSheet extends StatefulWidget {
  final SexActivitySaveCallback onSave;

  const LogSexActivityBottomSheet({
    super.key,
    required this.onSave,
  });

  @override
  State<LogSexActivityBottomSheet> createState() => _LogSexActivityBottomSheetState();
}

class _LogSexActivityBottomSheetState extends State<LogSexActivityBottomSheet> {
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  
  SexTypes? _selectedSexType;
  SexParticipationTypes? _selectedParticipation;
  SexProtectionTypes? _selectedProtection;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year, picked.month, picked.day, 
          _selectedDate.hour, _selectedDate.minute
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year, _selectedDate.month, _selectedDate.day, 
          picked.hour, picked.minute
        );
      });
    }
  }

  void _handleSave() {
    widget.onSave(
      _selectedDate,
      _selectedSexType,
      _selectedParticipation,
      _selectedProtection,
      _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        top: 16, left: 20, right: 20, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 32
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Drag Handle ---
            Center(
              child: Container(
                width: 32, height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Header ---
            Text(
              "Log Sex Activity", 
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // --- Date & Time Pickers (Pill Design) ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.date, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(DateFormat('d MMM yyyy').format(_selectedDate)),
                        onPressed: _selectDate,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time", style: theme.textTheme.bodySmall),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(DateFormat('HH:mm').format(_selectedDate)),
                        onPressed: _selectTime,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // --- Sex Type Selection ---
            Text("Sex Type", style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SexTypes.values.map((type) {
                return ChoiceChip(
                  label: Text(type.getDisplayName(l10n)),
                  selected: _selectedSexType == type,
                  onSelected: (val) => setState(() => _selectedSexType = val ? type : null),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // --- Participation ---
            Text("Participation", style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SexParticipationTypes.values.map((type) {
                final isSelected = _selectedParticipation == type;
                return ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    type.icon,
                    size: 18,
                    color: isSelected 
                        ? theme.colorScheme.onPrimaryContainer 
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  label: Text(type.getDisplayName(l10n)),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedParticipation = val ? type : null),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // --- Protection ---
            Text("Protection", style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SexProtectionTypes.values.map((type) {
                final isSelected = _selectedProtection == type;
                return ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    type.icon,
                    size: 18,
                    color: isSelected 
                        ? theme.colorScheme.onPrimaryContainer 
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  label: Text(type.getDisplayName(l10n)),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedProtection = val ? type : null),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // --- Notes ---
            Text(l10n.note, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLength: 500,
              maxLines: 1,
            ),

            const SizedBox(height: 24),

            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: () => Navigator.pop(context),
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