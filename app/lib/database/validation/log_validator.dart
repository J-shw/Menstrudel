import 'package:flutter/material.dart';
import 'package:menstrudel/utils/exceptions.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';

class LogValidator {
  final LogsRepository repository;

  LogValidator(this.repository);

  /// Validates a log's date, throwing exceptions for future or duplicate dates. 
  Future<void> validate(DateTime date, {int? idToExclude}) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final entryDate = DateUtils.dateOnly(date);

    if (entryDate.isAfter(today)) {
      throw FutureDateException('Logs cannot be for future dates.');
    }

    final isDuplicate = await repository.existsOnDate(date, excludeId: idToExclude);

    if (isDuplicate) {
      throw DuplicateLogException('A log already exists for this date.');
    }
  }
}