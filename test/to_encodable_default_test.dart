import 'package:json5/json5.dart';
import 'package:test/test.dart';

class ToMap {
  Map<String, dynamic> toMap() {
    return {
      'x': 1,
    };
  }
}

class ToJson {
  String toJson() => 'toJson';
}

class ToString {
  @override
  String toString() {
    return 'toString';
  }
}

void main() {
  test('to_map', () {
    expect(json5Encode(ToMap()), '{x:1}');
  });

  test('to_json', () {
    expect(json5Encode(ToJson()), "'toJson'");
  });

  test('to_string', () {
    expect(json5Encode(ToString()), "'toString'");
  });
}
