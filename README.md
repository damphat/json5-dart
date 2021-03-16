## JSON5 for dart and flutter
![Dart CI](https://github.com/damphat/json5-dart/workflows/Dart%20CI/badge.svg)

This *dart-package* is a ported version of [json5](https://github.com/json5/json5) which is written in pure *javascript*.

We use the same algorithms, so we have the same behaviors, the same specification.

But dart have different name convention, see the code below.

## Usage

```dart
import 'package:json5/json5.dart';

void main() {
  var obj = JSON5.parse('{                '
      '  /*  comment block  */            '
      '  name: {first: "phat"},           '
      '  lang: ["C++", "dart", "kotlin"], '
      '  nums: [NaN, Infinity, -Infinity] '
      '} // end object                    ');

  var compact = JSON5.stringify(obj);

  print(compact);

  var pretty = JSON5.stringify(obj, space: 2);

  print(pretty);
}
```

## Current limitations
- Only serialize classes which implement List and Map

## References
- [json5](https://json5.org/)
- [json5 in javascript](https://github.com/json5/json5)
