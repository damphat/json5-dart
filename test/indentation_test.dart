import 'package:json5/json5.dart';
import 'package:test/test.dart';

void main() {
  group('indentation', () {
    test('space: null', () {
      expect(JSON5.stringify({}), '{}');
      expect(JSON5.stringify({'x': 1}), '{x:1}');
      expect(JSON5.stringify({'x': 1, 'y': 2}), '{x:1,y:2}');

      expect(JSON5.stringify([]), '[]');
      expect(JSON5.stringify([1]), '[1]');
      expect(JSON5.stringify([1, 2]), '[1,2]');
    });

    test('space: 0', () {
      expect(JSON5.stringify({'x': 1}, space: 0), '{x:1}');
    });

    test('space: 2', () {
      expect(JSON5.stringify({'x': 1}, space: 2), '{\n  x: 1,\n}');
      expect(JSON5.stringify([1], space: 2), '[\n  1,\n]');
    });

    test('space: 2.5 (same as 2)', () {
      expect(JSON5.stringify({'x': 1}, space: 2.5), '{\n  x: 1,\n}');
      expect(JSON5.stringify([1], space: 2.5), '[\n  1,\n]');
    });

    test('space: "===="', () {
      expect(JSON5.stringify({'x': 1}, space: '===='), '{\n====x: 1,\n}');
      expect(JSON5.stringify([1], space: '===='), '[\n====1,\n]');
    });
    test('space: "1234567890123" (trim with limit 10 chars)', () {
      expect(JSON5.stringify({'x': 1}, space: '1234567890123'),
          '{\n1234567890x: 1,\n}');

      expect(
          JSON5.stringify([1], space: '123456789_123'), '[\n123456789_1,\n]');
    });
  });
}
