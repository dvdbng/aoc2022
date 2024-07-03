import 'dart:convert';
import 'dart:math';
import 'dart:collection';
import 'dart:convert';
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

class Point {
  int x, y;
  Point(this.x, this.y);

  bool operator ==(Object other) {
    if (other is Point) {
      return x == other.x && y == other.y;
    }
    return false;
  }

  int get hashCode {
    return x.hashCode ^ y.hashCode;
  }
  String toString() {
    return "($x, $y)";
  }

  Point dup() {
    return Point(x, y);
  }
}



int inOrder(dynamic a, dynamic b) {
  print("inOrder($a, $b)");
  if (a is num && b is num) {
    return a < b ? 1 : a == b ? 0 : -1;
  }
  if (a is List && b is List) {
    print("isList");
    for (int i = 0; i < min(a.length, b.length); i++) {
      final o = inOrder(a[i], b[i]);
      if (o != 0) return o;
    }
    return inOrder(a.length, b.length);
  }
  if (a is num) {
    return inOrder([a], b);
  }
  if (b is num) {
    return inOrder(a, [b]);
  }
  print("bad types $a, $b");
  return 0;
}


void main1() {
  final List<List<int>> map = [];
  final start = Point(0, 0);
  final end = Point(0, 0);
  final List<List<int>> vis = [];
  String? line = null;
  final queue = Queue<Point>();

  int score = 0;
  int idx = 1;
  dynamic? first = null;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    if (first == null && line != "") {
      first = jsonDecode(line!);
    } else if (first != null) {
      final second = jsonDecode(line!);
      print("$idx $first , $second -> ${inOrder(first, second)}");
      if (inOrder(first, second) == 1) {
        score += idx;
      }
      first = null;
      idx++;
    }
  }
  print(score);
}


void main() {
  String? line = null;

  final m1 = [[2]];
  final m2 = [[6]];
  final List<dynamic> packets = [
  m1, m2
  ];

  int score = 0;
  int idx = 1;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    if (line != "") {
      packets.add(jsonDecode(line!));
    }
  }
  packets.sort(inOrder);
  final ordered = packets.reversed.toList();
  print(ordered.map((i) => "$i").join("\n"));
  score = (ordered.indexOf(m1) + 1) * (ordered.indexOf(m2) + 1);
  print(score);
}
