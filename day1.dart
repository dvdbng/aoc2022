import 'dart:convert';
import 'dart:io';

void main() {
  print("Hello");
  String? line = null;
  var current = 0;
  var maxes = [0, 0, 0];
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    if (line == "") {
      if (current > maxes[0]) {
        maxes[0] = current;
        for (var i = 0; i < maxes.length - 1; i++) {
          if (maxes[i] > maxes[i+1]) {
            final tmp = maxes[i+1];
            maxes[i+1] = maxes[i];
            maxes[i] = tmp;
          } else {
            break;
          }
        }
      }
      current = 0;
    } else {
      current += int.parse(line!);
    }
  }
  print(maxes.reduce((a, b) => a + b));
}
