import 'dart:convert';
import 'dart:io';

final A = 'A'.codeUnits[0];
final Z = 'Z'.codeUnits[0];
final a = 'a'.codeUnits[0];
final z = 'z'.codeUnits[0];

bool contains(int a1, int a2, int b1, int b2) {
  return a1 <= b1 && a2 >= b2;
}

bool intersects(int a1, int a2, int b1, int b2) {
  return !(b2 < a1 || b1 > a2);
}

void main() {
  print("Hello");
  String? line = null;
  var score = 0;
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final ranges = line!.split(",");
    final r1 = ranges[0].split("-");
    final r2 = ranges[1].split("-");
    final a1 = int.parse(r1[0]);
    final a2 = int.parse(r1[1]);
    final b1 = int.parse(r2[0]);
    final b2 = int.parse(r2[1]);

    //if (contains(a1, a2, b1, b2) || contains(b1, b2, a1, a2)) {
    if (intersects(a1, a2, b1, b2)) {
      score += 1;
    }
  }
  print(score);
}
