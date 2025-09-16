/// Thrown when trying to create a period log on a date that already has one.
class DuplicateLogException implements Exception {
  final String message;
  DuplicateLogException(this.message);

  @override
  String toString() => message;
}

/// Thrown when trying to create a period log on a date in the future.
class FutureDateException implements Exception {
  final String message;
  FutureDateException(this.message);
}

/// A custom exception for errors related to scheduling notifications in the past.
class PastNotificationException implements Exception {
  final String message;

  const PastNotificationException([
    this.message = 'An error occurred while scheduling the notification.',
  ]);

  @override
  String toString() => 'PastNotificationException: $message';
}