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
  final Duration _maxDuration = const Duration(hours: 8);

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _startTime = TimeOfDay.fromDateTime(now);
    _endTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 6)));
  }

  DateTime _toDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
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
            label: l10n.start,
            selectedTime: _startTime,
            onTimeChanged: (newStartTime) {
              setState(() {
                final startDateTime = _toDateTime(_startTime);
                var endDateTime = _toDateTime(_endTime);
                if (endDateTime.isBefore(startDateTime)) {
                  endDateTime = endDateTime.add(const Duration(days: 1));
                }
                final duration = endDateTime.difference(startDateTime);

                _startTime = newStartTime;

                final newStartDateTime = _toDateTime(newStartTime);
                final newEndDateTime = newStartDateTime.add(duration);
                _endTime = TimeOfDay.fromDateTime(newEndDateTime);
              });
            },
          ),
          const SizedBox(height: 24),
          _buildTimePicker(
            label: l10n.end,
            selectedTime: _endTime,
            onTimeChanged: (newEndTime) {
              final startDateTime = _toDateTime(_startTime);
              var newEndDateTime = _toDateTime(newEndTime);

              if (newEndDateTime.isBefore(startDateTime)) {
                newEndDateTime = newEndDateTime.add(const Duration(days: 1));
              }

              final duration = newEndDateTime.difference(startDateTime);

              if (duration > _maxDuration) {
                final cappedEndDateTime = startDateTime.add(_maxDuration);
                setState(() {
                  _endTime = TimeOfDay.fromDateTime(cappedEndDateTime);
                });

                if (mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(l10n.tamponReminderDialog_tamponReminderMaxDuration)),
                    );
                }
              } else {
                setState(() {
                  _endTime = newEndTime;
                });
              }
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