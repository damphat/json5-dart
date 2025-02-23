## JSON5 for Dart and Flutter
![Dart CI](https://github.com/damphat/json5-dart/workflows/Dart%20CI/badge.svg)

This Dart package is a port of [JSON5](https://github.com/json5/json5), originally written in pure JavaScript.

It follows the same algorithms and specifications as the original JSON5, ensuring identical behavior.

However, Dart has different naming conventions—see the example below.

## Usage

```dart
import 'package:json5/json5.dart';

void main() {
  var obj = JSON5.parse('''
      {  
        /* Comment block */  
        name: { first: "Phat" },  
        lang: ["C++", "Dart", "Kotlin"],  
        nums: [NaN, Infinity, -Infinity]  
      } // End object
  ''');

  var compact = JSON5.stringify(obj);
  print(compact);

  var pretty = JSON5.stringify(obj, space: 2);
  print(pretty);
}
```

## References
- [JSON5 Official Site](https://json5.org/)
- [JSON5 JavaScript Implementation](https://github.com/json5/json5)
