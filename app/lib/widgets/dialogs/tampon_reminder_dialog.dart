import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class TimeSelectionDialog extends StatefulWidget {
  const TimeSelectionDialog({super.key});

  @override
  State<TimeSelectionDialog> createState() => _TimeSelectionDialogState();
}

class _TimeSelectionDialogState extends State<TimeSelectionDialog> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _startTime = TimeOfDay.fromDateTime(now);
    _endTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 6)));
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay selectedTime,
    required ValueChanged<TimeOfDay> onTimeChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (picked != null && picked != selectedTime) {
              onTimeChanged(picked);
            }
          },
          child: Text(
            selectedTime.format(context),
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.tamponReminderDialog_tamponReminderTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTimePicker(
            label: 'Start',
            selectedTime: _startTime,
            onTimeChanged: (newTime) {
              setState(() => _startTime = newTime);
            },
          ),
          const SizedBox(height: 24),
          _buildTimePicker(
            label: 'End',
            selectedTime: _endTime,
            onTimeChanged: (newTime) {
              setState(() => _endTime = newTime);
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'start': _startTime,
              'end': _endTime,
            });
          },
          child: Text(l10n.set),
        ),
      ],
    );
  }
}