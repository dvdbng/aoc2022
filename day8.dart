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


void main1() {
  print("Hello");
  String? line = null;
  int score = 0;
  final List<List<int>> map = [];
  final List<List<bool>> vis = [];

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final row = line!.codeUnits;
    map.add(row);
    var curh = 0;
    final List<bool> visrow = [];
    for (final h in row) {
      if (h > curh) {
        visrow.add(true);
          score++;
        curh = h;
      } else {
        visrow.add(false);
      }
    }
    curh = 0;
    for (int i = row.length - 1; i >= 0; i--) {
      final h = row[i];
      if (h > curh) {
        if (!visrow[i]) {
          visrow[i] = true;
          score++;
        }
        curh = h;
      }
    }
    vis.add(visrow);
  }
  for (int x = 0; x < map[0].length; x++) {
    var curh = 0;
    for (int y = 0; y < map.length; y++) {
      final h = map[y][x];
      if (h > curh) {
        if (!vis[y][x]) {
          vis[y][x] = true;
          score++;
        }
        curh = h;
      }
    }
    curh = 0;
    for (int y = map.length - 1; y >= 0; y--) {
      final h = map[y][x];
      if (h > curh) {
        if (!vis[y][x]) {
          vis[y][x] = true;
          score++;
        }
        curh = h;
      }
    }
  }
  print(score);
}

int cscore(List<List<int>> map, int x, int y) {
  final h = map[y][x];
  var score = 1;
  var dst = 0;
  for (int dx = x - 1; dx >= 0; dx--) {
    dst++;
    if (map[y][dx] >= h) break;
  }
  score *= dst;
  dst = 0;
  for (int dx = x + 1; dx < map[0].length; dx++) {
    dst++;
    if (map[y][dx] >= h) break;
  }
  score *= dst;
  dst = 0;
  for (int dy = y - 1; dy >= 0; dy--) {
    dst++;
    if (map[dy][x] >= h) break;
  }
  score *= dst;
  dst = 0;
  for (int dy = y + 1; dy < map.length; dy++) {
    dst++;
    if (map[dy][x] >= h) break;
  }
  score *= dst;
  dst = 0;
  return score;
}

void main() {
  print("Hello");
  String? line = null;
  int score = 0;
  final List<List<int>> map = [];
  final List<List<bool>> vis = [];

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final row = line!.codeUnits.map((c) => c - c0).toList();
    map.add(row);
  }



  print(cscore(map, 2, 1));


  for (int x = 0; x < map[0].length; x++) {
    for (int y = 0; y < map.length; y++) {
      final nscore = cscore(map, x, y);
      score = max(score, nscore);
    }
  }
  print(score);
}
