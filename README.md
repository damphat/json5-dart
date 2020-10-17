## JSON5 for dart and flutter

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

## Limitations
- [ ] cannot parse streams
- [ ] cannot run async mode
- [ ] only Map<> for json object
- [ ] only List<> for json array