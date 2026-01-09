import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sex/sex_log_entry.dart';
import 'package:menstrudel/models/sex/sex_participation_type_enum.dart';
import 'package:menstrudel/models/sex/sex_protection_type_enum.dart';
import 'package:menstrudel/models/sex/sex_type_enum.dart';

class EditSexLogBottomSheet extends StatefulWidget {
  final SexLogEntry log;
  final VoidCallback onDelete;
  final void Function(SexLogEntry) onSave;

  const EditSexLogBottomSheet({
    super.key,
    required this.log,
    required this.onDelete,
    required this.onSave,
  });

  @override
  State<EditSexLogBottomSheet> createState() => _EditSexLogBottomSheetState();
}

class _EditSexLogBottomSheetState extends State<EditSexLogBottomSheet> {
  bool _isEditing = false;

  late DateTime _editedDate;
  late SexTypes? _editedSexType;
  late SexParticipationTypes? _editedParticipation;
  late SexProtectionTypes? _editedProtection;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _resetEditableState();
  }

  void _resetEditableState() {
    _editedDate = widget.log.dateTime;
    _editedSexType = widget.log.sexType;
    _editedParticipation = widget.log.participationType;
    _editedProtection = widget.log.protectionType;
    _noteController = TextEditingController(text: widget.log.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedLog = widget.log.copyWith(
      dateTime: _editedDate,
      sexType: _editedSexType,
      participationType: _editedParticipation,
      protectionType: _editedProtection,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    widget.onSave(updatedLog);
    setState(() => _isEditing = false);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _editedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _editedDate = DateTime(picked.year, picked.month, picked.day, _editedDate.hour, _editedDate.minute);
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_editedDate),
    );
    if (picked != null) {
      setState(() {
        _editedDate = DateTime(_editedDate.year, _editedDate.month, _editedDate.day, picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDragHandle(theme),
          const SizedBox(height: 12),
          _buildHeader(context, l10n),
          const Divider(height: 24),
          if (_isEditing) _buildEditView(theme, l10n) else _buildReadOnlyView(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            _isEditing ? "Edit Sex Activity" : DateFormat('EEE, d MMM yyyy').format(widget.log.dateTime),
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (_isEditing)
          Row(
            children: [
              IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _isEditing = false)),
              IconButton(icon: Icon(Icons.check, color: colorScheme.primary), onPressed: _handleSave),
            ],
          )
        else
          Row(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => setState(() => _isEditing = true)),
              IconButton(
                icon: Icon(Icons.delete_outline, color: colorScheme.error),
                onPressed: () {
                  widget.onDelete();
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildReadOnlyView(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(theme, Icons.access_time, "Time", DateFormat('HH:mm').format(widget.log.dateTime)),
        if (widget.log.sexType != null) 
          _buildInfoRow(theme, widget.log.sexType!.icon, "Type", widget.log.sexType!.getDisplayName(l10n)),
        if (widget.log.participationType != null) 
          _buildInfoRow(theme, widget.log.participationType!.icon, "Participation", widget.log.participationType!.getDisplayName(l10n)),
        if (widget.log.protectionType != null) 
          _buildInfoRow(theme, widget.log.protectionType!.icon, "Protection", widget.log.protectionType!.getDisplayName(l10n)),
        if (widget.log.note != null) ...[
          const SizedBox(height: 16),
          Text(l10n.note, style: theme.textTheme.bodySmall),
          Text(widget.log.note!, style: theme.textTheme.bodyLarge),
        ]
      ],
    );
  }

  Widget _buildEditView(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildPickerPill(l10n.date, DateFormat('d MMM').format(_editedDate), Icons.calendar_today, _selectDate)),
            const SizedBox(width: 12),
            Expanded(child: _buildPickerPill("Time", DateFormat('HH:mm').format(_editedDate), Icons.access_time, _selectTime)),
          ],
        ),
        const SizedBox(height: 20),
        _buildChipSection("Sex Type", SexTypes.values, _editedSexType, (val, type) => setState(() => _editedSexType = val ? type : null), l10n: l10n),
        _buildChipSection("Participation", SexParticipationTypes.values, _editedParticipation, (val, type) => setState(() => _editedParticipation = val ? type : null), l10n: l10n),
        _buildChipSection("Protection", SexProtectionTypes.values, _editedProtection, (val, type) => setState(() => _editedProtection = val ? type : null), l10n: l10n),
        const SizedBox(height: 16),

        Text(l10n.note, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        TextField(controller: _noteController, maxLength: 500),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text("$label: ", style: theme.textTheme.bodyLarge),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPickerPill(String label, String value, IconData icon, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(
          onPressed: onTap,
          icon: Icon(icon, size: 18),
          label: Text(value),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), alignment: Alignment.centerLeft),
        ),
      ],
    );
  }

  Widget _buildChipSection<T>(String title, List<T> values, T? selectedValue, Function(bool, T) onSelected, {AppLocalizations? l10n}) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: values.map((type) {
            final dynamic item = type;
            return ChoiceChip(
              showCheckmark: false,
              avatar: item.icon != null ? Icon(item.icon, size: 18, color: theme.colorScheme.onSurfaceVariant) : null,
              label: Text(item.getDisplayName(l10n)),
              selected: selectedValue == type,
              onSelected: (val) => onSelected(val, type),
            );
          }).toList(),
        ),
      ],
    );
  }
}