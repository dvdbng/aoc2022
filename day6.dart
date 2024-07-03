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

void main1() {
  print("Hello");
  String? line = null;
  var score = 0;
  final List<List<String>> stacks = [];
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    for (int i = 4; i < line!.length; i += 1) {
      final chars = line.substring(i - 4, i);
      assert(chars.length == 4);
      if (Set.from(chars.codeUnits).length == 4) {
        print(i);
        return;
      }
    }
  }
  //print(score);
}


void main() {
  print("Hello");
  String? line = null;
  var score = 0;
  final List<List<String>> stacks = [];
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    for (int i = 14; i < line!.length; i += 1) {
      final chars = line.substring(i - 14, i);
      assert(chars.length == 14);
      if (Set.from(chars.codeUnits).length == 14) {
        print(i);
        return;
      }
    }
  }
  //print(score);
}
