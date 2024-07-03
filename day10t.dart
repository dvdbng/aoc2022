import 'dart:convert';
import 'dart:math';
import 'dart:io';

final A = 'A'.codeUnits[0];
final Z = 'Z'.codeUnits[0];
final a = 'a'.codeUnits[0];
final z = 'z'.codeUnits[0];
final c0 = '0'.codeUnits[0];

bool contains(int a1, int a2, int b1, int b2) {
  return a1 <= b1 && a2 >= b2;
}

bool intersects(int a1, int a2, int b1, int b2) {
  return !(b2 < a1 || b1 > a2);
}

void main() {
  print("Hello");
  String? line = null;
  int score = 0;
  int c = 1;
  int x = 1;

  final map = List.generate(8, (_) =>
    List.generate(40, (_) => " ")
  );

  void cycle() {
    final row = (c-1) ~/ 40;
    final col = (c-1) % 40;
    if (col >= x - 1 && col <= x + 1) {
      map[row][col] = "#";
    }
  }

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final row = line!.split(" ");
    if (row[0] == "noop") {
      c++; cycle();
    } else if (row[0] == "addx") {
      c++; cycle();
      c++;
      x += int.parse(row[1]);
      cycle();
    }
  }
  print(map.map((l) => l.join("")).join("\n"));
  print(score);
}


void main1() {
  print("Hello");
  String? line = null;
  int score = 0;
  int c = 1;
  int x = 1;

  void cycle() {
    if ((c-20)%40 == 0) {
      score += x*c;
      //print("c=$c, x=$x  == ${c*x}");
    }
  }

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final row = line!.split(" ");
    if (row[0] == "noop") {
      c++; cycle();
    } else if (row[0] == "addx") {
      c++; cycle();
      c++;
      x += int.parse(row[1]);
      cycle();
    }
  }
  print(score);
}
