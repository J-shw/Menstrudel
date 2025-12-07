import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_enum.dart';

typedef SanitaryProductSaveCallback = void Function(
  DateTime logTime,
  String? note,
  SanitaryProducts type,
  DateTime reminderEndTime,
);

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
  double _reminderHours = 4.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _reminderHours = _selectedType.maxDurationHours.toDouble();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  void _handleSave(AppLocalizations l10n) {
    setState(() {
      _errorMessage = null;
    });

    final startTime = _getStartDateTime();
    final reminderEndTime = _getReminderEndTime();
    final now = DateTime.now();
    
    if (startTime.isAfter(now)) {
      setState(() {
        _errorMessage = l10n.sanitaryEntrySheet_futureLogTimeError;
      });
      return;
    }
    
    if (reminderEndTime.isBefore(now)) {
      setState(() {
        _errorMessage = l10n.sanitaryEntrySheet_pastReminderTimeError;
      });
      return; 
    }
    
    final String? noteToSave = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();
    
    widget.onSave(startTime, noteToSave, _selectedType, reminderEndTime);
    Navigator.pop(context);
  }

  DateTime _getStartDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute);
  }

  DateTime _getReminderEndTime() {
    return _getStartDateTime().add(Duration(hours: _reminderHours.round()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final endTime = TimeOfDay.fromDateTime(_getReminderEndTime());

    return Padding(
      padding: EdgeInsets.only(
        top: 16, 
        left: 20, 
        right: 20, 
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
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null) 
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_rounded, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // --- Header ---
            Text(
              l10n.sanitaryEntrySheet_logSanitaryProduct, 
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // --- Type Selection ---
            Text(l10n.type, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: SanitaryProducts.values.map((type) {
                return ChoiceChip(
                  label: Text(type.getDisplayName(l10n)),
                  selected: _selectedType == type,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                        if (_reminderHours > type.maxDurationHours) {
                          _reminderHours = type.maxDurationHours.toDouble();
                        }
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 8),
            Text(l10n.time, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),

            // --- Time and Duration Logic ---
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _selectTime,
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.start, style: theme.textTheme.bodySmall),
                            Row(
                              children: [
                                Text(
                                  _startTime.format(context), 
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const Icon(Icons.arrow_forward, color: Colors.grey),

                      // End Time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(l10n.end, style: theme.textTheme.bodySmall),
                          Text(
                            endTime.format(context),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const Divider(height: 30),

                  // Duration Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.sanitaryEntrySheet_setReminderDuration, style: theme.textTheme.bodyMedium),
                      Text(
                        '${_reminderHours.round()} ${l10n.hours}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    year2023: false,
                    value: _reminderHours,
                    min: 1,
                    max: _selectedType.maxDurationHours.toDouble(),
                    divisions: _selectedType.maxDurationHours - 1,
                    label: '${_reminderHours.round()} h',
                    onChanged: (double value) {
                      setState(() {
                        _reminderHours = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(l10n.note, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            // --- Notes ---
            TextField(
              controller: _noteController,
              maxLength: 500,
              maxLines: 1,
            ),

            const SizedBox(height: 24),

            // --- Buttons ---
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
                    onPressed: () {
                      _handleSave(l10n);
                    },
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