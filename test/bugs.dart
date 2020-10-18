import 'package:json5/json5.dart';
import 'package:test/test.dart';

void bugs() {
  test('non_string_keys', () {
    expect(JSON5.stringify({1: 1}), '{1:1}');
  });
}
