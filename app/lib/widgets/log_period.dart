import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomEntryDialog extends StatefulWidget {
const SymptomEntryDialog({super.key});

@override
State<SymptomEntryDialog> createState() => _SymptomEntryDialogState();
}

class _SymptomEntryDialogState extends State<SymptomEntryDialog> {
DateTime _selectedDate = DateTime.now();
String? _selectedSymptom;

final List<String> _symptomOptions = [
	'Headache',
	'Fatigue',
	'Cramps',
	'Nausea',
	'Mood Swings',
	'Bloating',
	'Acne',
];

final List<String> flowLabels = ["Low", "Medium", "High"];

double _currentDiscreteSliderValue = 1;

@override
Widget build(BuildContext context) {
	final ColorScheme colorScheme = Theme.of(context).colorScheme;

	return AlertDialog(
		title: const Text('Log period'),
		content: SingleChildScrollView(
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					ListTile(
						leading: Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant),
						title: Text(
							'Select Date:',
							style: TextStyle(color: colorScheme.onSurface),
						),
						subtitle: Text(
							DateFormat('dd/MM/yyyy').format(_selectedDate),
							style: TextStyle(
								color: colorScheme.onSurfaceVariant,
								fontWeight: FontWeight.bold,
							),
						),
						onTap: () async {
							final DateTime? picked = await showDatePicker(
							context: context,
							initialDate: _selectedDate,
							firstDate: DateTime(2000),
							lastDate: DateTime.now(),
							builder: (context, child) {
								return Theme(
								data: Theme.of(context).copyWith(
									colorScheme: colorScheme,
								),
								child: child!,
								);
							},
							);
							if (picked != null && picked != _selectedDate) {
							setState(() {
								_selectedDate = picked;
							});
							}
						},
					),
					const SizedBox(height: 15),
					Text('Flow'),
					Slider(
						year2023: false,
						value: _currentDiscreteSliderValue,
						max: 2,
						divisions: 2,
						label: flowLabels[_currentDiscreteSliderValue.toInt()],
						onChanged: (double value) {
							setState(() {
							_currentDiscreteSliderValue = value;
							});
						},
					),

					const SizedBox(height: 15),

					DropdownButtonFormField<String>(
						decoration: InputDecoration(
							labelText: 'Select Symptom',
							border: const OutlineInputBorder(),
							labelStyle: TextStyle(color: colorScheme.onSurface),
							hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
						),
						value: _selectedSymptom,
						hint: const Text('Choose a symptom'),
						items: _symptomOptions.map((String symptom) {
							return DropdownMenuItem<String>(
							value: symptom,
							child: Text(symptom, style: TextStyle(color: colorScheme.onSurface)),
							);
						}).toList(),
						onChanged: (String? newValue) {
							setState(() {
							_selectedSymptom = newValue;
						});
					},
					dropdownColor: colorScheme.surface,
					style: TextStyle(color: colorScheme.onSurface),
					),
				],
			),
		),
		actions: <Widget>[
			TextButton(
			onPressed: () {
				Navigator.of(context).pop();
			},
			child: const Text('Cancel'),
			),
			ElevatedButton(
			onPressed: () {
				if (_selectedSymptom != null) {
				Navigator.of(context).pop({
					'date': _selectedDate,
					'symptom': _selectedSymptom,
				});
				} else {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(
					content: Text('Please select a symptom', style: TextStyle(color: colorScheme.onError)),
					backgroundColor: colorScheme.error,
					behavior: SnackBarBehavior.floating,
					),
				);
				}
			},
			child: const Text('Add'),
			),
		],
		);
	}
}