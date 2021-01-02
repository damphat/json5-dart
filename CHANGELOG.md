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