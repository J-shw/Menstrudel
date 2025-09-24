import 'package:flutter/material.dart';
import 'package:menstrudel/l10n/app_localizations.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String contentText;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.contentText,
    required this.onConfirm,
    this.confirmButtonText = 'Confirm',
    this.isDestructive = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog.adaptive(
      title: Text(title, textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Text(
          contentText,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          child: Text(l10n.cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? colorScheme.error : colorScheme.primary,
            foregroundColor: isDestructive ? colorScheme.onError : colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}