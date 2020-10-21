import 'package:json5/json5.dart';
import 'package:test/test.dart';

void bugs() {
  test('non_string_keys', () {
    expect(JSON5.stringify({1: 1}), "{'1':1}");
    expect(JSON5.stringify({-1: 1}), "{'-1':1}");
    expect(JSON5.stringify({null: 1}), '{null:1}');
    expect(JSON5.stringify({true: 1}), '{true:1}');
    expect(JSON5.stringify({false: 1}), '{false:1}');
    expect(JSON5.stringify({double.infinity: 1}), '{Infinity:1}');
  });
}
