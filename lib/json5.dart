import 'dart:convert';

import 'src/parse.dart' as parser;
import 'src/stringify.dart' as render;

/// [JSON5] contains 2 static methods [parse()] and [stringify()]
///
/// The name [JSON5] is uppercase so that it compatible with document.
///
/// If you love dart convention. You can also use [json5Encode()] and
///  [json5Decode()] instead.
abstract class JSON5 {
  /// Convert the object to json5 string.
  ///
  /// Currently, only objects that inherit from [Map] or [List]
  /// are supported.
  ///
  /// The altenative is [json5Encode(string)]
  static String stringify(dynamic object, {space = 0}) {
    return render.stringify(object, null, space);
  }

  /// Parses the string and return the json object.
  ///
  /// If the input string is not [json] or [json5], an
  /// [SyntaxException] will be thrown.
  ///
  /// The altenative is [json5Decode(string)]
  static dynamic parse(String string) {
    return parser.parse(string, null);
  }
}

/// Convert the object to json5 string.
///
/// Currently, only objects that inherit from [Map] or [List]
/// are supported.
///
/// The altenative is [JSON5.stringify(string)]
String json5Encode(dynamic object, {space = 0}) {
  return render.stringify(object, null, space);
}

/// Parses the string and return the json object.
///
/// If the input string is not [json] or [json5], an
/// [SyntaxException] will be thrown.
///
/// You can use the altenative method [JSON5.parse(string)]
dynamic json5Decode(String string) {
  return parser.parse(string, null);
}
