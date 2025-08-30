/// Thrown when trying to create a period log on a date that already has one.
class DuplicateLogException implements Exception {
  final String message;
  DuplicateLogException(this.message);

  @override
  String toString() => message;
}