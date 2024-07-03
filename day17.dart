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

  int dist(Point other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }
}

class Range {
  int s, e;
  Range(this.s, this.e) {
    assert(this.s <= this.e);
  }
  bool operator ==(Object other) {
    if (other is Range) {
      return s == other.s && e == other.e;
    }
    return false;
  }
  String toString() {
    return "[$s, $e]";
  }
  int size() {
    return e - s;
  }

  bool intersects(Range other) {
    return !(e < other.s || s > other.e);
  }

  bool mergeable(Range other) {
    return this.intersects(other) || s == other.e || e == other.s;
  }

  Range merge(Range other) {
    return Range(min(s, other.s), max(e, other.e));
  }

  clamp(Range other) {
    this.s = max(other.s, this.s);
    this.e = min(other.e, this.e);
  }
}

class Res {
  int growth;
  String next;
  Res(this.growth, this.next);
}

final int rock = 1;
final int air = 0;
final empty = [0,0,0,0,0,0,0];
final List<List<List<int>>> figures = List.generate(5, (_) => List.generate(4, (_) => [...empty]));
final Map<String, Res> nexts = {};
final Map<String, Res> nexts_1m = {};

final List<List<int>> map = [];

bool isEmpty(List<int> m) {
  return m.every((m) => m == air);
}

bool wouldCollide(int fid, Point pos) {
  if (pos.x < 0 || pos.y < 0) {
    return true;
  }
  final figure = figures[fid];
  for (int dy = 0; dy < figure.length; ++dy) {
    for (int dx = 0; dx < figure[dy].length; ++dx) {
      if (pos.x + dx >= map[0].length) {
        if (figure[dy][dx] == rock) return true;
        continue;
      }
      if (pos.y + dy >= map.length) continue;
      if (map[pos.y + dy][pos.x + dx] == rock && figure[dy][dx] == rock) {
        return true;
      }
    }
  }
  return false;
}

void commit(int fid, Point pos) {
  assert(!wouldCollide(fid, pos));
  final figure = figures[fid];
  for (int dy = 0; dy < figure.length; ++dy) {
    for (int dx = 0; dx < figure[dy].length; ++dx) {
      if (figure[dy][dx] != rock) continue;
      while (pos.y + dy >= map.length) map.add([...empty]);
      map[pos.y + dy][pos.x + dx] = rock;
    }
  }
}

String? signature(int fid, int windn, int maxh) {
  if (map.length < 25) return null;
  List<int> mapn = [];
  for(int y = 0; y < 25; ++y) {
    int rown = 0;
    final row = map[maxh - y];
    for(int x = 0; x < 7; ++x) {
      rown = rown | (row[x] << x);
    }
    mapn.add(rown);
  }
  return "${String.fromCharCode(a + fid)}${String.fromCharCode(33+windn)}${mapn.map((n) => String.fromCharCode(33+n)).join('')}";
}


void main() {
figures[0][0][0] = rock;
figures[0][0][1] = rock;
figures[0][0][2] = rock;
figures[0][0][3] = rock;

figures[1][0][1] = rock;
figures[1][1][0] = rock;
figures[1][1][1] = rock;
figures[1][1][2] = rock;
figures[1][2][1] = rock;

figures[2][0][0] = rock;
figures[2][0][1] = rock;
figures[2][0][2] = rock;
figures[2][1][2] = rock;
figures[2][2][2] = rock;

figures[3][0][0] = rock;
figures[3][1][0] = rock;
figures[3][2][0] = rock;
figures[3][3][0] = rock;

figures[4][0][0] = rock;
figures[4][0][1] = rock;
figures[4][1][0] = rock;
figures[4][1][1] = rock;

  int score = 0;
  final pattern = stdin.readLineSync(encoding: utf8)!;
  int rockn = 0;
  int airn = 0;
  map.add([...empty]);

  int lastCacheMiss = 0;
  String? after = null;

  while (rockn < 20220) {
    if (!isEmpty(map.last)) map.add([...empty]);

    int lasth = map.length - 1;
    while (lasth >= 0 && isEmpty(map[lasth])) lasth--;
    //print("$lasth");

    final figureid = rockn % 5;
    rockn++;
    String? before = signature(figureid, airn % pattern.length, lasth);

    Point figurePos =  Point(2, lasth + 4);
    //print("orig $figurePos");
    while (true) {
      int windir = pattern[airn % pattern.length] == ">" ? 1 : -1;
      airn++;
      figurePos.x += windir;
      if (wouldCollide(figureid, figurePos)) {
        figurePos.x -= windir;
      }
      //print("after wind $windir $figurePos");

      figurePos.y--;
      if (wouldCollide(figureid, figurePos)) {
        figurePos.y++;
        break;
      }
      //print("after fall $figurePos");
    }
    //print("final $figurePos");
    commit(figureid, figurePos);

    int lasth2 = map.length - 1;
    while (lasth2 >= 0 && isEmpty(map[lasth2])) lasth2--;
    after = signature(rockn % 5, airn % pattern.length, lasth2);
    if (before == null || after == null) continue;

    if (nexts.containsKey(before)) {
      assert(after == nexts[before]!.next);
      assert((lasth2 - lasth) == nexts[before]!.growth);
    } else {
      print("cacheMiss $rockn");
      nexts[before] = Res(lasth2 - lasth, after);
    }

    //print(map.map((l) => l.join("")).join("\n"));
    //print("---");
  }
  int lasth = map.length - 1;
  while (lasth > 0 && isEmpty(map[lasth])) lasth--;
  print(lasth + 1);


  final m1 = 1000000;
  for (final e in nexts.entries) {
    String sig = e.key;
    int growth = 0;
    for (int i = 0; i < m1; i++) {
      final nxt = nexts[sig]!;
      sig = nxt.next;
      growth += nxt.growth;
    }
    nexts_1m[e.key] = Res(growth, sig);
  }


  String sig = after!;
  int tt = 1000000000000;

  while (rockn < tt) {
    if ((tt - rockn) > m1) {
      rockn+=m1;
      final nxt = nexts_1m[sig]!;
      sig = nxt.next;
      lasth = lasth + nxt.growth;
    } else {
      rockn++;
      final nxt = nexts[sig]!;
      sig = nxt.next;
      lasth = lasth + nxt.growth;
    }
  }
  print(lasth+1);

}
