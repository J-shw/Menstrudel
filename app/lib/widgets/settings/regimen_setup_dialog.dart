import 'package:flutter/material.dart';
import 'package:menstrudel/models/pills/pill_regimen.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class RegimenSetupDialog extends StatefulWidget {
  const RegimenSetupDialog({super.key});

  @override
  State<RegimenSetupDialog> createState() => _RegimenSetupDialogState();
}

class _RegimenSetupDialogState extends State<RegimenSetupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'My Pill Pack');
  final _activeController = TextEditingController(text: '21');
  final _placeboController = TextEditingController(text: '7');
  DateTime _startDate = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newRegimen = PillRegimen(
        name: _nameController.text,
        activePills: int.parse(_activeController.text),
        placeboPills: int.parse(_placeboController.text),
        startDate: _startDate,
        isActive: true,
      );
      Navigator.of(context).pop(newRegimen);
    }
  }

  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _activeController.dispose();
    _placeboController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.regimenSetupWidget_setUpPillRegimen),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.regimenSetupWidget_packName),
                validator: (value) => value!.isEmpty ? l10n.regimenSetupWidget_pleaseEnterAName : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _activeController,
                      decoration: InputDecoration(labelText: l10n.regimenSetupWidget_activePills),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty || int.tryParse(value) == null ? l10n.regimenSetupWidget_enterANumber : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _placeboController,
                      decoration: InputDecoration(labelText: l10n.regimenSetupWidget_placeboPills),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty || int.tryParse(value) == null ? l10n.regimenSetupWidget_enterANumber : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.regimenSetupWidget_firstDayOfThisPack),
                subtitle: Text(MaterialLocalizations.of(context).formatFullDate(_startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectStartDate,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          onPressed: _submitForm,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}