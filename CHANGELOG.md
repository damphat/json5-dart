## 0.8.1

- Replaced pedantic package with lints package, fixed some analysis issues (#16)

## 0.8.1

- Updated package description, fixed analysis issues (#15)

## 0.8.0

- feat: values without decimal point or exponent should be `int` type

## 0.7.0

- feat: toEncodable parameter
- feat: toDecodable is default to `toMap()` then `toJson()` then `toString()`

```dart
    json5Encode(obj, toEncodable: (v) => v.toMap())
```

## 0.6.1

- feat: serialize iterable objects
- fix: JSON.stringify return non-null String
- fix: indentication can be number and string

## 0.6.0

- Migrating to null safety

## 0.5.5

- hotfix: dart not support '\0' escape

## 0.5.4

- Fix: RangeError when stringify a string with ending '\0'

## 0.5.3

- fix: json5Decode() should return Map<String, dynamic> instead of Map<dynamic, dynamic>

## 0.5.2

- support runtime-js, flutter web

## 0.5.1

- fix: cannot stringify object if their keys are not string .

## 0.5.0

- supports Map, List, null, num, bool, String
- `JSON5.parse( aString );`
- `JSON5.stringify( anObj )`
- `JSON5.stringify( abObj, space:2 )`
- `json5Decode( aString );`
- `json5Encode( anObj )`
- `json5Encode( abObj, space:2 )`
