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
