import 'package:json5/json5.dart';
import 'package:test/test.dart';

class Foo {
  @override
  String toString() {
    return 'foo';
  }
}

void main() {
  test('toEncodable', () {
    expect(
      json5Encode(Foo(), toEncodable: (value) => value.toString()),
      "'foo'",
    );
  });
}
