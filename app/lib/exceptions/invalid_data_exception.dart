class InvalidDataException implements Exception {
  final String message;

  InvalidDataException(this.message);

  @override
  String toString() {
    return message;
  }
}
