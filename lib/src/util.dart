import 'unicode.dart' as unicode;

bool isSpaceSeparator(c) {
  return c is String && unicode.Space_Separator.hasMatch(c);
}

bool isIdStartChar(c) {
  return c is String &&
      (RegExp(r'[a-zA-Z_$]').hasMatch(c) || unicode.ID_Start.hasMatch(c));
}

bool isIdContinueChar(c) {
  return c is String &&
      // FIXME: check unicode
      (RegExp(r'[a-z0-9A-Z_\u200C\u200D$]').hasMatch(c) ||
          unicode.ID_Continue.hasMatch(c));
}

bool isDigit(c) {
  return c is String && RegExp(r'[0-9]').hasMatch(c);
}

bool isHexDigit(c) {
  return c is String && RegExp(r'[0-9A-Fa-f]').hasMatch(c);
}
