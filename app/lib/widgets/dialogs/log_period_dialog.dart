import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomEntryDialog extends StatefulWidget {
  const SymptomEntryDialog({super.key});

  @override
  State<SymptomEntryDialog> createState() => _SymptomEntryDialogState();
}

class _SymptomEntryDialogState extends State<SymptomEntryDialog> {
  DateTime _selectedDate = DateTime.now();
  final Set<String> _selectedSymptoms = {};
  Set<int> _flowSelection = {1};

  final List<String> _symptomOptions = [
    'Headache',
    'Fatigue',
    'Cramps',
    'Nausea',
    'Mood Swings',
    'Bloating',
    'Acne',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Your Day'),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 24.0),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(DateFormat('EEEE, d MMMM yyyy').format(_selectedDate)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  alignment: Alignment.centerLeft,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: _pickDate,
              ),

              const SizedBox(height: 24),

              Text('Flow', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Light')),
                        ButtonSegment(value: 1, label: Text('Moderate')),
                        ButtonSegment(value: 2, label: Text('Heavy')),
                      ],
                      selected: _flowSelection,
                      onSelectionChanged: (Set<int> newSelection) {
                        setState(() {
                          if (newSelection.isNotEmpty) {
                            _flowSelection = newSelection;
                          }
                        });
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity(horizontal: 0, vertical: -1),
                      ),
                    ),
                  )
                ]
              ),

              const SizedBox(height: 24),

              Text('Symptoms (Optional)', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _symptomOptions.map((symptom) {
                  return FilterChip(
                    label: Text(symptom),
                    selected: _selectedSymptoms.contains(symptom),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'date': _selectedDate,
              'flow': _flowSelection.first,
              'symptoms': _selectedSymptoms.toList(),
            });
          },
          child: const Text('Log'),
        ),
      ],
    );
  }
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}