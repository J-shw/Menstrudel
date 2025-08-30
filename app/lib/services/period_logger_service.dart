import 'package:flutter/material.dart';
import 'package:menstrudel/widgets/sheets/symptom_entry_sheet.dart';
import 'package:menstrudel/models/period_logs/period_logs.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/utils/exceptions.dart';

class PeriodLoggerService {
  static Future<bool> showAndLogPeriod(BuildContext context, DateTime selectedDate) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SymptomEntrySheet(selectedDate: selectedDate),
    );
    final periodsRepo = PeriodsRepository();

    if (result == null || !context.mounted) {
      return false; 
    }

    try {
      final DateTime? date = result['date'];
      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Date was not provided.')),
        );
        return false; // Failure
      }

      final newEntry = PeriodLogEntry(
        date: date,
        symptoms: result['symptoms'] ?? [],
        flow: result['flow'] ?? 0,
      );

      try {
        await periodsRepo.createPeriodLog(newEntry);
      } on DuplicateLogException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        return false;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Log saved!')),
      );
      
      return true;

    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save log. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
  }
}