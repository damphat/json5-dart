import 'package:json5/json5.dart';
import 'package:json5/src/syntax_exception.dart';
import 'package:test/test.dart';

var error = throwsA(TypeMatcher<SyntaxException>());
void main() {
  group('syntax error', () {
    var badJson = [
      ['', error],
      [' ', error],
      ['x', error],
      ['1x', error],
      ['+', error],
      ['"', error],
      ['"a', error],
      ['//comment 1', error],
      ['//comment\n', error],
      ['/*1', error],
      ['/**1', error],
      ['[', error],
      ['[1', error],
      ['[1,', error],
      ['nul', error],
      ['[[]', error],
      ['{1:1}', error],
      ['{"x":1', error],
      ['{"x":}', error],
      ['{"x"1}', error],
      ['{"x",1}', error],
    ];
    for (var item in badJson) {
      test(item[0], () {
        if (item[1] == error) {
          expect(() => json5Decode(item[0] as String), item[1]);
        } else {
          expect(json5Decode(item[0] as String), item[1]);
        }
      });
    }
  });

  group('separators', () {
    var seps = [
      ['[]', []],
      [
        '[1]',
        [1]
      ],
      [
        '[1,]',
        [
          1,
        ]
      ],
      ['[,]', error],
      ['[,1]', error],
      ['[1,,]', error],
    ];
    for (var item in seps) {
      if (item[1] == error) {
        test('${item[0]} throws', () {
          expect(() => json5Decode(item[0] as String), item[1]);
        });
      } else {
        test(item[0], () {
          expect(json5Decode(item[0] as String), item[1]);
        });
      }
    }
  });
}
