import 'util.dart' as util;
import 'dart:math' show min;

class _Stringify {
  final stack = [];
  var indent = '';
  var propertyList;
  var replacerFunc;
  var gap = '';
  var quote;

  String eval(dynamic value, replacer, space) {
    assert(replacer == null);
    assert(space is num || space is String);

    if (space is num) {
      if (space > 0) {
        space = min<num>(10, space.floor());
        gap = '          '.substring(0, space);
      }
    } else if (space is String) {
      gap = space.substring(0, 10);
    }

    return serializeProperty('', {'': value});
  }

  String quoteString(String value) {
    final quotes = {
      "'": 0.1,
      '"': 0.2,
    };

    const replacements = {
      "'": "\\'",
      '"': '\\"',
      '\\': '\\\\',
      '\b': '\\b',
      '\f': '\\f',
      '\n': '\\n',
      '\r': '\\r',
      '\t': '\\t',
      '\v': '\\v',
      '\0': '\\0',
      '\u2028': '\\u2028',
      '\u2029': '\\u2029',
    };

    var product = '';

    for (var i = 0; i < value.length; i++) {
      final c = value[i];
      switch (c) {
        case "'":
        case '"':
          quotes[c]++;
          product += c;
          continue;

        case '\0':
          if (util.isDigit(value[i + 1])) {
            product += '\\x00';
            continue;
          }
      }

      if (replacements.containsKey(c)) {
        product += replacements[c];
        continue;
      }

      if (c.codeUnitAt(0) < ' '.codeUnitAt(0)) {
        var hexString = c.codeUnitAt(0).toRadixString(16);
        product += '\\x' + ('00' + hexString).substring(hexString.length);
        continue;
      }

      product += c;
    }

    final quoteChar =
        quote ?? quotes.keys.reduce((a, b) => (quotes[a] < quotes[b]) ? a : b);

    // FIXME replaceall + doall?
    product = product.replaceAll(
        RegExp(quoteChar, dotAll: true), replacements[quoteChar]);

    return quoteChar + product + quoteChar;
  }

  String serializeProperty(dynamic key, dynamic holder) {
    Object value = holder[key];

    if (value == null) return 'null';
    switch (value) {
      case true:
        return 'true';
      case false:
        return 'false';
    }

    if (value is String) {
      return quoteString(value); // , false?
    }

    if (value is num) {
      return value.toString();
    }

    if (value is List) return serializeArray(value);
    if (value is Map) return serializeObject(value);

    return null; // undefined
  }

  String serializeKey(String key) {
    if (key.isEmpty) {
      return quoteString(key);
    }

    final firstChar = key[0];
    if (!util.isIdStartChar(firstChar)) {
      return quoteString(key);
    }

    for (var i = firstChar.length; i < key.length; i++) {
      if (!util.isIdContinueChar(key[i])) {
        return quoteString(key);
      }
    }

    return key;
  }

  String serializeObject(value) {
    if (stack.contains(value)) {
      throw Exception('Converting circular structure to JSON5');
    }

    stack.add(value);

    var stepback = indent;
    indent = indent + gap;

    var keys = propertyList ?? value.keys;
    var partial = [];
    for (final key in keys) {
      final propertyString = serializeProperty(key, value);
      if (propertyString != null) {
        var member = serializeKey(key.toString()) + ':';
        if (gap != '') {
          member += ' ';
        }
        member += propertyString;
        partial.add(member);
      }
    }

    var final_;
    if (partial.isEmpty) {
      final_ = '{}';
    } else {
      var properties;
      if (gap == '') {
        properties = partial.join(',');
        final_ = '{' + properties + '}';
      } else {
        var separator = ',\n' + indent;
        properties = partial.join(separator);
        final_ = '{\n' + indent + properties + ',\n' + stepback + '}';
      }
    }

    stack.removeLast();

    indent = stepback;
    return final_;
  }

  String serializeArray(List value) {
    if (stack.contains(value)) {
      throw Exception('Converting circular structure to JSON5');
    }

    stack.add(value);

    var stepback = indent;
    indent = indent + gap;

    var partial = [];
    for (var i = 0; i < value.length; i++) {
      final propertyString = serializeProperty(i, value);
      partial.add((propertyString != null) ? propertyString : 'null');
    }

    var final_;
    if (partial.isEmpty) {
      final_ = '[]';
    } else {
      if (gap == '') {
        var properties = partial.join(',');
        final_ = '[' + properties + ']';
      } else {
        var separator = ',\n' + indent;
        var properties = partial.join(separator);
        final_ = '[\n' + indent + properties + ',\n' + stepback + ']';
      }
    }

    stack.removeLast();
    indent = stepback;
    return final_;
  }
}

String stringify(dynamic value, replacer, space) {
  return _Stringify().eval(value, replacer, space);
}
