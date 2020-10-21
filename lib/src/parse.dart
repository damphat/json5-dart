import 'package:json5/src/syntax_exception.dart';

import 'token.dart';
import 'util.dart' as util;

String source;
String parseState;
List stack;
int pos;
int line;
int column;
Token token;
String key;
Object root;

Object parse(String text, reviver) {
  source = text;
  parseState = 'start';
  stack = [];
  pos = 0;
  line = 1;
  column = 0;
  token = null;
  key = null;
  root = null;

  do {
    token = lex();

    // This code is unreachable.
    // if (!parseStates[parseState]) {
    //     throw invalidParseState()
    // }

    parseStates[parseState]();
  } while (token.type != 'eof');

  if (reviver is Function) {
    return internalize({'': root}, '', reviver);
  }

  return root;
}

List<Token> split(String text) {
  source = text;
  parseState = 'start';
  stack = [];
  pos = 0;
  line = 1;
  column = 0;
  token = null;
  key = null;
  root = null;

  var ret = <Token>[];
  for (;;) {
    token = lex();
    if (token.type == 'eof') {
      return ret;
    } else {
      ret.add(token);
    }
  }
}

dynamic internalize(holder, name, reviver) {
  final value = holder[name];
  if (value != null && value is Map) {
    for (final key in value.keys) {
      final replacement = internalize(value, key, reviver);
      if (replacement == null) {
        value.remove(key);
      } else {
        value[key] = replacement;
      }
    }
  }

  return reviver.call(holder, name, value);
}

String lexState;
String buffer;
bool doubleQuote;
var sign;
String c;

// not null;
Token lex() {
  lexState = 'default';
  buffer = '';
  doubleQuote = false;
  sign = 1;

  for (;;) {
    c = peek();

    // This code is unreachable.
    // if (!lexStates[lexState]) {
    //     throw invalidLexState(lexState)
    // }

    final token = lexStates[lexState]();
    if (token != null) {
      return token;
    }
  }
}

String peek() {
  if (pos >= 0 && pos < source.length) return source[pos];
  return null;
}

String read() {
  final c = peek();

  if (c == '\n') {
    line++;
    column = 0;
  } else if (c != null) {
    column += c.length;
  } else {
    column++;
  }

  if (c != null) {
    pos += c.length;
  }

  return c;
}

Map<String, Token Function()> lexStates = {
  'default': () {
    switch (c) {
      case '\t':
      case '\v':
      case '\f':
      case ' ':
      case '\u00A0':
      case '\uFEFF':
      case '\n':
      case '\r':
      case '\u2028':
      case '\u2029':
        read();
        return null; //$

      case '/':
        read();
        lexState = 'comment';
        return null; //$

      default:
        if (c == null) {
          read();
          return newToken('eof', null);
        }
    }

    if (util.isSpaceSeparator(c)) {
      read();
      return null; //$
    }

    // This code is unreachable.
    // if (!lexStates[parseState]) {
    //     throw invalidLexState(parseState)
    // }

    return lexStates[parseState]();
  },
  'comment': () {
    switch (c) {
      case '*':
        read();
        lexState = 'multiLineComment';
        return null; //$

      case '/':
        read();
        lexState = 'singleLineComment';
        return null; //$
    }

    throw invalidChar(read());
  },
  'multiLineComment': () {
    switch (c) {
      case '*':
        read();
        lexState = 'multiLineCommentAsterisk';
        return null; //$

      default:
        if (c == null) {
          throw invalidChar(read());
        }
    }

    read();
    return null;
  },
  'multiLineCommentAsterisk': () {
    switch (c) {
      case '*':
        read();
        return;

      case '/':
        read();
        lexState = 'default';
        return null; //$

      default:
        if (c == null) {
          throw invalidChar(read());
        }
    }

    read();
    lexState = 'multiLineComment';
    return null;
  },
  'singleLineComment': () {
    switch (c) {
      case '\n':
      case '\r':
      case '\u2028':
      case '\u2029':
        read();
        lexState = 'default';
        return null; //$

      default:
        if (c == null) {
          read();
          return newToken('eof', null);
        }
    }

    read();
    return null;
  },
  'value': () {
    switch (c) {
      case '{':
      case '[':
        return newToken('punctuator', read());

      case 'n':
        read();
        literal('ull');
        return newToken('null', null);

      case 't':
        read();
        literal('rue');
        return newToken('boolean', true);

      case 'f':
        read();
        literal('alse');
        return newToken('boolean', false);

      case '-':
      case '+':
        if (read() == '-') {
          sign = -1;
        }

        lexState = 'sign';
        return null; //$

      case '.':
        buffer = read();
        lexState = 'decimalPointLeading';
        return null; //$

      case '0':
        buffer = read();
        lexState = 'zero';
        return null; //$

      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        buffer = read();
        lexState = 'decimalInteger';
        return null; //$

      case 'I':
        read();
        literal('nfinity');
        return newToken('numeric', double.infinity);

      case 'N':
        read();
        literal('aN');
        return newToken('numeric', double.nan);

      case '"':
      case "'":
        doubleQuote = (read() == '"');
        buffer = '';
        lexState = 'string';
        return null; //$
    }

    throw invalidChar(read());
  },
  'identifierNameStartEscape': () {
    if (c != 'u') {
      throw invalidChar(read());
    }

    read();
    final u = unicodeEscape();
    switch (u) {
      case '\$':
      case '_':
        break;

      default:
        if (!util.isIdStartChar(u)) {
          throw invalidIdentifier();
        }

        break;
    }

    buffer += u;
    lexState = 'identifierName';
    return null;
  },
  'identifierName': () {
    switch (c) {
      case '\$':
      case '_':
      case '\u200C':
      case '\u200D':
        buffer += read();
        return null; //$

      case '\\':
        read();
        lexState = 'identifierNameEscape';
        return null; //$
    }

    if (util.isIdContinueChar(c)) {
      buffer += read();
      return null; //$
    }

    return newToken('identifier', buffer);
  },
  'identifierNameEscape': () {
    if (c != 'u') {
      throw invalidChar(read());
    }

    read();
    final u = unicodeEscape();
    switch (u) {
      case '\$':
      case '_':
      case '\u200C':
      case '\u200D':
        break;

      default:
        if (!util.isIdContinueChar(u)) {
          throw invalidIdentifier();
        }

        break;
    }

    buffer += u;
    lexState = 'identifierName';
    return null;
  },
  'sign': () {
    switch (c) {
      case '.':
        buffer = read();
        lexState = 'decimalPointLeading';
        return null; //$

      case '0':
        buffer = read();
        lexState = 'zero';
        return null; //$

      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        buffer = read();
        lexState = 'decimalInteger';
        return null; //$

      case 'I':
        read();
        literal('nfinity');
        return newToken('numeric', sign * double.infinity);

      case 'N':
        read();
        literal('aN');
        return newToken('numeric', double.nan);
    }

    throw invalidChar(read());
  },
  'zero': () {
    switch (c) {
      case '.':
        buffer += read();
        lexState = 'decimalPoint';
        return null; //$

      case 'e':
      case 'E':
        buffer += read();
        lexState = 'decimalExponent';
        return null; //$

      case 'x':
      case 'X':
        buffer += read();
        lexState = 'hexadecimal';
        return null; //$
    }

    return newToken('numeric', sign * 0);
  },
  'decimalInteger': () {
    switch (c) {
      case '.':
        buffer += read();
        lexState = 'decimalPoint';
        return null; //$

      case 'e':
      case 'E':
        buffer += read();
        lexState = 'decimalExponent';
        return null; //$
    }

    if (util.isDigit(c)) {
      buffer += read();
      return null; //$
    }

    return newToken('numeric', sign * double.parse(buffer));
  },
  'decimalPointLeading': () {
    if (util.isDigit(c)) {
      buffer += read();
      lexState = 'decimalFraction';
      return null; //$
    }

    throw invalidChar(read());
  },
  'decimalPoint': () {
    switch (c) {
      case 'e':
      case 'E':
        buffer += read();
        lexState = 'decimalExponent';
        return null; //$
    }

    if (util.isDigit(c)) {
      buffer += read();
      lexState = 'decimalFraction';
      return null; //$
    }

    return newToken('numeric', sign * double.parse(buffer));
  },
  'decimalFraction': () {
    switch (c) {
      case 'e':
      case 'E':
        buffer += read();
        lexState = 'decimalExponent';
        return null; //$
    }

    if (util.isDigit(c)) {
      buffer += read();
      return null; //$
    }

    return newToken('numeric', sign * double.parse(buffer));
  },
  'decimalExponent': () {
    switch (c) {
      case '+':
      case '-':
        buffer += read();
        lexState = 'decimalExponentSign';
        return null; //$
    }

    if (util.isDigit(c)) {
      buffer += read();
      lexState = 'decimalExponentInteger';
      return null; //$
    }

    throw invalidChar(read());
  },
  'decimalExponentSign': () {
    if (util.isDigit(c)) {
      buffer += read();
      lexState = 'decimalExponentInteger';
      return null; //$
    }

    throw invalidChar(read());
  },
  'decimalExponentInteger': () {
    if (util.isDigit(c)) {
      buffer += read();
      return null; //$
    }

    return newToken('numeric', sign * double.parse(buffer));
  },
  'hexadecimal': () {
    if (util.isHexDigit(c)) {
      buffer += read();
      lexState = 'hexadecimalInteger';
      return null; //$
    }

    throw invalidChar(read());
  },
  'hexadecimalInteger': () {
    if (util.isHexDigit(c)) {
      buffer += read();
      return null; //$
    }

    return newToken('numeric', sign * double.parse(buffer));
  },
  'string': () {
    switch (c) {
      case '\\':
        read();
        buffer += escape();
        return null; //$

      case '"':
        if (doubleQuote) {
          read();
          return newToken('string', buffer);
        }

        buffer += read();
        return null; //$

      case "'":
        if (!doubleQuote) {
          read();
          return newToken('string', buffer);
        }

        buffer += read();
        return null; //$

      case '\n':
      case '\r':
        throw invalidChar(read());

      case '\u2028':
      case '\u2029':
        separatorChar(c);
        break;

      default:
        if (c == null) {
          throw invalidChar(read());
        }
    }

    buffer += read();
    return null;
  },
  'start': () {
    switch (c) {
      case '{':
      case '[':
        return newToken('punctuator', read());

      // This code is unreachable since the default lexState handles eof.
      // case null:
      //     return newToken('eof')
    }

    lexState = 'value';
    return null;
  },
  'beforePropertyName': () {
    switch (c) {
      case '\$':
      case '_':
        buffer = read();
        lexState = 'identifierName';
        return null; //$

      case '\\':
        read();
        lexState = 'identifierNameStartEscape';
        return null; //$

      case '}':
        return newToken('punctuator', read());

      case '"':
      case "'":
        doubleQuote = (read() == '"');
        lexState = 'string';
        return null; //$
    }

    if (util.isIdStartChar(c)) {
      buffer += read();
      lexState = 'identifierName';
      return null; //$
    }

    throw invalidChar(read());
  },
  'afterPropertyName': () {
    if (c == ':') {
      return newToken('punctuator', read());
    }

    throw invalidChar(read());
  },
  'beforePropertyValue': () {
    lexState = 'value';
    return null;
  },
  'afterPropertyValue': () {
    switch (c) {
      case ',':
      case '}':
        return newToken('punctuator', read());
    }

    throw invalidChar(read());
  },
  'beforeArrayValue': () {
    if (c == ']') {
      return newToken('punctuator', read());
    }

    lexState = 'value';
    return null;
  },
  'afterArrayValue': () {
    switch (c) {
      case ',':
      case ']':
        return newToken('punctuator', read());
    }

    throw invalidChar(read());
  },
  'end': () {
    // This code is unreachable since it's handled by the default lexState.
    // if (c == null) {
    //     read()
    //     return newToken('eof')
    // }

    throw invalidChar(read());
  },
};

Token newToken(String type, Object value) {
  return Token(type, value, line, column);
}

void literal(String s) {
  var len = s.length;
  for (var i = 0; i < len; i++) {
    final p = peek();

    if (p != s[i]) {
      throw invalidChar(read());
    }

    read();
  }
}

String escape() {
  final c = peek();
  switch (c) {
    case 'b':
      read();
      return '\b';

    case 'f':
      read();
      return '\f';

    case 'n':
      read();
      return '\n';

    case 'r':
      read();
      return '\r';

    case 't':
      read();
      return '\t';

    case 'v':
      read();
      return '\v';

    case '0':
      read();
      if (util.isDigit(peek())) {
        throw invalidChar(read());
      }

      return '\0';

    case 'x':
      read();
      return hexEscape();

    case 'u':
      read();
      return unicodeEscape();

    case '\n':
    case '\u2028':
    case '\u2029':
      read();
      return '';

    case '\r':
      read();
      if (peek() == '\n') {
        read();
      }

      return '';

    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      throw invalidChar(read());
    default:
      if (c == null) {
        throw invalidChar(read());
      }
  }

  return read();
}

String hexEscape() {
  var buffer = '';
  var c = peek();

  if (!util.isHexDigit(c)) {
    throw invalidChar(read());
  }

  buffer += read();

  c = peek();
  if (!util.isHexDigit(c)) {
    throw invalidChar(read());
  }

  buffer += read();

  return String.fromCharCode(int.parse(buffer, radix: 16));
}

String unicodeEscape() {
  var buffer = '';
  var count = 4;

  while (count-- > 0) {
    final c = peek();
    if (!util.isHexDigit(c)) {
      throw invalidChar(read());
    }

    buffer += read();
  }

  return String.fromCharCode(int.parse(buffer, radix: 16));
}

final Map<String, void Function()> parseStates = {
  'start': () {
    if (token.type == 'eof') {
      throw invalidEOF();
    }

    push();
  },
  'beforePropertyName': () {
    switch (token.type) {
      case 'identifier':
      case 'string':
        key = token.value;
        parseState = 'afterPropertyName';
        return null; //$

      case 'punctuator':
        // This code is unreachable since it's handled by the lexState.
        // if (token.value != '}') {
        //     throw invalidToken()
        // }

        pop();
        return null; //$

      case 'eof':
        throw invalidEOF();
    }

    // This code is unreachable since it's handled by the lexState.
    // throw invalidToken()
  },
  'afterPropertyName': () {
    // This code is unreachable since it's handled by the lexState.
    // if (token.type != 'punctuator' || token.value != ':') {
    //     throw invalidToken()
    // }

    if (token.type == 'eof') {
      throw invalidEOF();
    }

    parseState = 'beforePropertyValue';
  },
  'beforePropertyValue': () {
    if (token.type == 'eof') {
      throw invalidEOF();
    }

    push();
  },
  'beforeArrayValue': () {
    if (token.type == 'eof') {
      throw invalidEOF();
    }

    if (token.type == 'punctuator' && token.value == ']') {
      pop();
      return null; //$
    }

    push();
  },
  'afterPropertyValue': () {
    // This code is unreachable since it's handled by the lexState.
    // if (token.type != 'punctuator') {
    //     throw invalidToken()
    // }

    if (token.type == 'eof') {
      throw invalidEOF();
    }

    switch (token.value) {
      case ',':
        parseState = 'beforePropertyName';
        return null; //$

      case '}':
        pop();
    }

    // This code is unreachable since it's handled by the lexState.
    // throw invalidToken()
  },
  'afterArrayValue': () {
    // This code is unreachable since it's handled by the lexState.
    // if (token.type != 'punctuator') {
    //     throw invalidToken()
    // }

    if (token.type == 'eof') {
      throw invalidEOF();
    }

    switch (token.value) {
      case ',':
        parseState = 'beforeArrayValue';
        return null; //$

      case ']':
        pop();
    }

    // This code is unreachable since it's handled by the lexState.
    // throw invalidToken()
  },
  'end': () {
    // This code is unreachable since it's handled by the lexState.
    // if (token.type != 'eof') {
    //     throw invalidToken()
    // }
  },
};

bool isObject(dynamic value) => value is Map || value is List;
void push() {
  var value;

  switch (token.type) {
    case 'punctuator':
      switch (token.value) {
        case '{':
          value = <String, dynamic>{};
          break;

        case '[':
          value = <dynamic>[];
          break;
      }

      break;

    case 'null':
    case 'boolean':
    case 'numeric':
    case 'string':
      value = token.value;
      break;

    // This code is unreachable.
    // default:
    //     throw invalidToken()
  }

  if (root == null) {
    root = value;
  } else {
    final parent = stack[stack.length - 1];
    if (parent is List) {
      parent.add(value);
    } else {
      parent[key] = value;
    }
  }

  if (isObject(value)) {
    stack.add(value);

    if (value is List) {
      parseState = 'beforeArrayValue';
    } else {
      parseState = 'beforePropertyName';
    }
  } else {
    final current = stack.isEmpty ? null : stack[stack.length - 1];
    if (current == null) {
      parseState = 'end';
    } else if (current is List) {
      parseState = 'afterArrayValue';
    } else {
      parseState = 'afterPropertyValue';
    }
  }
}

void pop() {
  stack.removeLast();

  final current = stack.isEmpty ? null : stack[stack.length - 1];
  if (current == null) {
    parseState = 'end';
  } else if (current is List) {
    parseState = 'afterArrayValue';
  } else {
    parseState = 'afterPropertyValue';
  }
}

// This code is unreachable.
// dynamic invalidParseState () {
//     return new Error(`JSON5: invalid parse state '${parseState}'`)
// }

// This code is unreachable.
// dynamic invalidLexState (state) {
//     return new Error(`JSON5: invalid lex state '${state}'`)
// }

SyntaxException invalidChar(c) {
  if (c == null) {
    return syntaxError('JSON5: invalid end of input at ${line}:${column}');
  }

  return syntaxError(
      "JSON5: invalid character '${formatChar(c)}' at ${line}:${column}");
}

SyntaxException invalidEOF() {
  return syntaxError('JSON5: invalid end of input at ${line}:${column}');
}

// This code is unreachable.
// dynamic invalidToken () {
//     if (token.type == 'eof') {
//         return syntaxError("JSON5: invalid end of input at ${line}:${column}")
//     }

//     final c = String.fromCodePoint(token.value.codePointAt(0))
//     return syntaxError("JSON5: invalid character '${formatChar(c)}' at ${line}:${column}")
// }

SyntaxException invalidIdentifier() {
  column -= 5;
  return syntaxError(
      'JSON5: invalid identifier character at ${line}:${column}');
}

void separatorChar(c) {
  // FIXME: how to print error
  print(
      "JSON5: '${formatChar(c)}' in strings is not valid ECMAScript; consider escaping");
}

String formatChar(String c) {
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

  if (replacements[c] != null) {
    return replacements[c];
  }

  if (c.codeUnitAt(0) < ' '.codeUnitAt(0)) {
    final hexString = c.codeUnitAt(0).toRadixString(16);
    return '\\x' + ('00' + hexString).substring(hexString.length);
  }

  return c;
}

SyntaxException syntaxError(String message) {
  final err = SyntaxException(message, line, column);
  return err;
}
