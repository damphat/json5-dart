import 'package:json5/json5.dart';
import 'package:test/test.dart';

void main() {
  group('unicode escape', () {
    var escape = [
      ['\\0', '\u0000'],
      ['\\b', '\u0008'],
      ['\\t', '\u0009'],
      ['\\n', '\u000A'],
      ['\\v', '\u000B'],
      ['\\f', '\u000C'],
      ['\\r', '\u000D'],
      ['\\\\', '\\'],
      ['\\"', '"'],
      ["\\'", "'"],
      ['\\u0000', '\u0000'],
      ['\\u1234', '\u1234'],
      ['\\u5678', '\u5678'],
      ['\\u9abc', '\u9abc'],
      ['\\udefA', '\udefA'],
      ['\\uBCDE', '\uBCDE'],
      ['\\uF012', '\uF012'],
      ['\\x09', '\u0009'],
      ['\\x90', '\u0090'],
    ];

    quote(String src) {
      return '"$src"';
    }

    for (var item in escape) {
      test('$item', () {
        expect(json5Decode(quote(item[0])), item[1]);
      });
    }
  });
}
