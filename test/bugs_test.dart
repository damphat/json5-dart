import 'package:json5/json5.dart';
import 'package:test/test.dart';

void main() {
  test('should return type Map<string, dynamic>', () {
    // BUG:
    // '_InternalLinkedHashMap<dynamic, dynamic>' is not
    // a subtype of 'Map<String, dynamic>'
    Map<String, dynamic>? obj = JSON5.parse('{x: 1}');
    expect(obj, {'x': 1});
  });

  test('non_string_keys', () {
    expect(JSON5.stringify({1: 1}), "{'1':1}");
    expect(JSON5.stringify({-1: 1}), "{'-1':1}");
    expect(JSON5.stringify({null: 1}), '{null:1}');
    expect(JSON5.stringify({true: 1}), '{true:1}');
    expect(JSON5.stringify({false: 1}), '{false:1}');
    expect(JSON5.stringify({double.infinity: 1}), '{Infinity:1}');
  });

  test('null char at the end', () {
    // BUG:
    // RangeError: not in inclusive range 0..3
    expect(JSON5.stringify('abc\u0000'), "'abc\\0'");
  });

  test('dart does not support backslash-zero escape (\\0)', () {
    // BUG:
    // javascript has '\0' but dart has not
    expect(JSON5.stringify('0'), "'0'");
    expect(JSON5.stringify('\0'), "'0'");
    expect(JSON5.stringify('\u0000'), "'\\0'");
  });
}
