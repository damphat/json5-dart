import 'dart:io';

import 'package:json5/json5.dart';

void main() {
  dynamic state;
  while (true) {
    stdout.write('json5>');
    var src = stdin.readLineSync();
    if (src == null) {
      print('break');
      return;
    }
    switch (src) {
      case '':
        continue;
      case '?':
      case 'h':
      case 'help':
      case '.help':
        print('JSON5 demonstration:');
        print(' type in your json string');
        print(' it will print out pretty ');
        print(' ');
        print('Commands');
        print('> help     : document');
        print('> exit     : quit the app');
        print('> clear    : clear the console');
        continue;
      case 'exit':
      case 'quit':
        return;
      case 'cls':
      case 'clear':
        for (var i = 0; i < stdout.terminalLines; i++) {
          stdout.writeln();
        }
        continue;
    }
    try {
      state = JSON5.parse(src);
      print(JSON5.stringify(state, space: 2));
    } catch (e) {
      print(e);
    }
  }
}
