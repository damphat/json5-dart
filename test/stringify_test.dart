import 'package:json5/json5.dart';
import 'package:test/test.dart';

void main() {
  group('object', () {
    var x1 = [
      {'x': 1},
      const {'x': 1},
      <dynamic, dynamic>{'x': 1},
      <Object, Object>{'x': 1},
      <String, num>{'x': 1},
      <String, int>{'x': 1},
    ];

    for (var item in x1) {
      test('${item.runtimeType} $item', () {
        expect(json5Encode(item), '{x:1}');
      });
    }
  });

  group('array', () {
    var items = [
      [1, 2],
      const [1, 2],
      {1, 2},
      [1, 2].map((e) => e),
    ];

    for (var item in items) {
      test('${item.runtimeType} $item', () {
        expect(json5Encode(item), '[1,2]');
      });
    }
  });

  group('primitives', () {
    var items = [
      [null, 'null'],
      [true, 'true'],
      [false, 'false'],
      [0.0, '0.0'],
      [-0.0, '-0.0'],
      [double.infinity, 'Infinity'],
      [double.negativeInfinity, '-Infinity'],
      [double.nan, 'NaN'],
      [-1.525e-10, '-1.525e-10'],
      ['😁', "'😁'"],
      ['\b\f\r\n\t', "'\\b\\f\\r\\n\\t'"],
      ['\\', "'\\\\'"],
      ['"', "'\"'"],
      ["'", '"\'"'],
      ["'\"", "'\\'\"'"],
      ['\u0019', "'\\x19'"],
      ['\u0000', "'\\0'"],
    ];

    for (var item in items) {
      test('${item[0].runtimeType} $item', () {
        expect(json5Encode(item[0]), item[1]);
      });
    }
  });
}
