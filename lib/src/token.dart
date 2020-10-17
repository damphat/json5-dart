
class Token {
  final String type;
  final Object value;
  final int line;
  final int column;
  Token(this.type, this.value, this.line, this.column);

  @override
  String toString() => '[$type: $value]';
}
