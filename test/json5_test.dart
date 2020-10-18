import 'package:json5/json5.dart';
import 'package:test/test.dart';

import 'bugs.dart';

void main() {
  bugs();

  group('JSON.parse', () {
    test('primitives', () {
      expect(JSON5.parse('null'), isNull);
      expect(JSON5.parse('true'), isTrue);
      expect(JSON5.parse('false'), isFalse);
      expect(JSON5.parse('-90e+09'), -90e+09);
      expect(JSON5.parse('NaN'), isNaN);
      expect(JSON5.parse('Infinity'), double.infinity);
      expect(JSON5.parse('-Infinity'), -double.infinity);
    });

    test('string-unicode', () {
      expect(JSON5.parse(r'"👌😁👍"'), '👌😁👍');
    });
    test('string-escape', () {
      expect(JSON5.parse(r'"\b\f\r\n\t\\"'), '\b\f\r\n\t\\');
      expect(JSON5.parse(r'"\u0123 \u4567"'), '\u0123 \u4567');
      expect(JSON5.parse(r'"\u8901 \uabcd"'), '\u8901 \uabcd');
      expect(JSON5.parse(r'"\uefAB \uCDEF"'), '\uefAB \uCDEF');
      expect(JSON5.parse(r'"\uefAB \uCDEF"'), '\uefAB \uCDEF');
      expect(JSON5.parse(r'"\x20"'), ' ');
    });

    test('JSON5.stringify-compact', () {
      expect(
          JSON5.stringify({
            'x': [1, 2]
          }),
          '{x:[1,2]}');
    });
    test('JSON5.stringify - pretty', () {
      var actual = JSON5.stringify({
        'x': [1, 2]
      }, space: 2);
      expect(actual, '{\n  x: [\n    1,\n    2,\n  ],\n}');
    });
  });

  test('json5Decode', () {
    expect(json5Decode("{'x':[1,2]}"), {
      'x': [1, 2]
    });
  });

  test('json5Encode', () {
    expect(
        json5Encode({
          'x': [1, 2]
        }),
        '{x:[1,2]}');
  });
}
