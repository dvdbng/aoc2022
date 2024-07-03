import 'dart:convert';
import 'dart:io';

final A = 'A'.codeUnits[0];
final Z = 'Z'.codeUnits[0];
final a = 'a'.codeUnits[0];
final z = 'z'.codeUnits[0];

void main1() {
  print("Hello");
  String? line = null;
  var score = 0;
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    String h1 = line!.substring(0, line.length ~/ 2);
    String h2 = line.substring(line.length ~/ 2);
    assert(h1.length == h2.length);
    final common = Set.from(h1.codeUnits).intersection(Set.from(h2.codeUnits));
    assert(common.length == 1);
    final int item = common.first;
    score += item >= a && item <= z ? item - a + 1 : item - A + 27;
  }
  print(score);
}


void main() {
  print("Hello");
  String? line = null;
  var score = 0;
  int i = 0;
  var common;
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    if (i==0) {
      common = Set.from(line!.codeUnits);
    } else {
      common.retainAll(line!.codeUnits);
    }
    if (i == 2) {
      assert(common.length == 1);
      final int item = common.first;
      score += item >= a && item <= z ? item - a + 1 : item - A + 27;
    }
    i = (i + 1) % 3;
  }
  print(score);
}
