import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class CustomSymptomDialog extends StatefulWidget {
  const CustomSymptomDialog({super.key});

  @override
  State<CustomSymptomDialog> createState() => _CustomSymptomDialogState();
}

class _CustomSymptomDialogState extends State<CustomSymptomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog.adaptive(
      title: Text("Add custom symptom", textAlign: TextAlign.center),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a custom symptom" : null,
              ),
              //const SizedBox(height: 16),
              // Checkbox(
              //   value: _isDefault,
              //   onChanged: (value) {
              //     setState(() {
              //       _isDefault = value ?? false;
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_nameController.text);
          },
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
