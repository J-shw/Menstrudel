import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmButtonText;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmButtonText = 'Confirm',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(confirmButtonText),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
        ),
      ],
    );
  }
}