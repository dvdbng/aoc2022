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
    if (line == "") break;
    stacks.add(line!.split("").reversed.toList());
  }
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    // move n from n to n
    final parts = line!.split(" ");
    final count = int.parse(parts[1]);
    final from = int.parse(parts[3]);
    final to = int.parse(parts[5]);
    for (int i = 0; i < count; ++i) {
      stacks[to - 1].add(stacks[from - 1].removeLast());
    }
  }
  print(stacks.map((s) => s.isEmpty ? "" : s.removeLast()).join(""));
  //print(score);
}


void main() {
  print("Hello");
  String? line = null;
  var score = 0;
  final List<List<String>> stacks = [];
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    if (line == "") break;
    stacks.add(line!.split("").reversed.toList());
  }
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    // move n from n to n
    final parts = line!.split(" ");
    final count = int.parse(parts[1]);
    final from = int.parse(parts[3]);
    final to = int.parse(parts[5]);
    for (int i = 0; i < count; ++i) {
      final froms = stacks[from - 1];
      stacks[to - 1].add(froms[froms.length - count + i]);
    }
    for (int i = 0; i < count; ++i) {
      stacks[from - 1].removeLast();
    }
  }
  print(stacks.map((s) => s.isEmpty ? "" : s.removeLast()).join(""));
  //print(score);
}
