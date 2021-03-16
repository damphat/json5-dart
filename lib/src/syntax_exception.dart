class SyntaxException implements Exception {
  final String message;
  final int? lineNumber;
  final int? columnNumber;
  SyntaxException(this.message, this.lineNumber, this.columnNumber);
  @override
  String toString() {
    return 'SyntaxException: $message';
  }
}
