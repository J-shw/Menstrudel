import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomEntrySheet extends StatefulWidget {
  const SymptomEntrySheet({super.key});

  @override
  State<SymptomEntrySheet> createState() => _SymptomEntrySheetState();
}

class _SymptomEntrySheetState extends State<SymptomEntrySheet> {
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
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Log Your Day',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 24),

            // --- Date Picker ---
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

            // --- Flow Selection ---
            Text('Flow', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
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
            ),
            const SizedBox(height: 24),

            // --- Symptoms ---
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
            const SizedBox(height: 24),
            // --- Action Buttons ---
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop({
                        'date': _selectedDate,
                        'flow': _flowSelection.first,
                        'symptoms': _selectedSymptoms.toList(),
                      });
                    },
                    child: const Text('Log'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
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