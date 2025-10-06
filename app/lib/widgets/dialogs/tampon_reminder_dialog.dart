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
  late DateTime _finalEndDateTime;

  Duration _currentDuration = Duration.zero;
  bool _isDurationValid = true;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _startTime = TimeOfDay.fromDateTime(now);
    _endTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 6)));
    _updateDurationAndDateTime();
  }

  DateTime _toDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  void _updateDurationAndDateTime() {
    final startDateTime = _toDateTime(_startTime);
    var endDateTime = _toDateTime(_endTime);

    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    final duration = endDateTime.difference(startDateTime);
    setState(() {
      _currentDuration = duration;
      _isDurationValid = duration <= _maxDuration;
      _finalEndDateTime = endDateTime;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Future<void> _selectTime({required bool isStartTime}) async {
    final initialTime = isStartTime ? _startTime : _endTime;
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (newTime != null) {
      if (isStartTime) {
        final newStartDateTime = _toDateTime(newTime);
        final newEndDateTime = newStartDateTime.add(_currentDuration);
        setState(() {
          _startTime = newTime;
          _endTime = TimeOfDay.fromDateTime(newEndDateTime);
        });
      } else {
        setState(() {
          _endTime = newTime;
        });
      }
      _updateDurationAndDateTime();
    }
  }

  Widget _buildTimeDisplay({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Text(
              time.format(context),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.tamponReminderDialog_tamponReminderTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildTimeDisplay(
              label: l10n.start,
              time: _startTime,
              onTap: () => _selectTime(isStartTime: true),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  const Icon(Icons.arrow_downward, color: Colors.grey),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isDurationValid
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _formatDuration(_currentDuration),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isDurationValid
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            _buildTimeDisplay(
              label: l10n.end,
              time: _endTime,
              onTap: () => _selectTime(isStartTime: false),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: !_isDurationValid
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        l10n.tamponReminderDialog_tamponReminderMaxDuration,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox(height: 24),
            ),
            if (_isDurationValid) const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isDurationValid
                      ? () {
                          Navigator.pop(context, _finalEndDateTime);
                        }
                      : null,
                  child: Text(l10n.set),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}