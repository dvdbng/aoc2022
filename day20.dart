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
class Point3 {
  int x, y, z;
  Point3(this.x, this.y, this.z);

  bool operator ==(Object other) {
    if (other is Point3) {
      return x == other.x && y == other.y && z == other.z;
    }
    return false;
  }

  int get hashCode {
    return x.hashCode ^ y.hashCode ^ z.hashCode;
  }
  String toString() {
    return "($x, $y, $z)";
  }

  Point3 dup() {
    return Point3(x, y, z);
  }

  List<Point3> neigh() {
    return [
      Point3(x+1, y, z),
      Point3(x-1, y, z),
      Point3(x, y+1, z),
      Point3(x, y-1, z),
      Point3(x, y, z+1),
      Point3(x, y, z-1),
    ];
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
  bool contains(int p) {
    return p>=s && p <= e;
  }

  clamp(Range other) {
    this.s = max(other.s, this.s);
    this.e = min(other.e, this.e);
  }
}

final Set<Point3> map = new Set();

void main1() {
  int score = 0;
  String? line = null;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(",").map((s) => int.parse(s)).toList();
    map.add(Point3(parts[0],parts[1],parts[2]));
  }
  for (final point in map) {
    for (int dx in [-1, 1]) {
      if (!map.contains(Point3(point.x + dx, point.y, point.z))) {
        score += 1;
      }
    }
    for (int dy in [-1, 1]) {
      if (!map.contains(Point3(point.x, point.y + dy, point.z))) {
        score += 1;
      }
    }
    for (int dz in [-1, 1]) {
      if (!map.contains(Point3(point.x, point.y, point.z + dz))) {
        score += 1;
      }
    }
  }
  print(score);
}

List<int> file = [];

void swap(int from, int to, int dir) {
  for (int i = from; i < to; i+= dir) {
    final tmp = file[i+dir];
    file[i + dir] = file[i];
    file[i] = tmp;
  }
}

class Num {
  int pos, new_pos, val;
  Num orig_next;
  Num next;
  Range(this.pos, this.new_pos, this.val, Num? nxt, Num? orig) {
    this.next = nxt ?? this;
    this.orig_next = orig ?? this;
  }
}

bool solve(int solved_after) {
  for (int i = 0; i<solved_after; ++i) {
    if (((i - file[i]) % file.length) == (solved_after - 1)) {
      file.insert(solved_after, file.remoteAt(i));
      if (solve(file, solved_after - 1)) return true;
      file.insert(i, file.remoteAt(solved_after - 1));
    }
  }
}

Num skip(Num start, int n) {
  for (int i = 0; i < n; ++i) {
    start = start.next;
  }
  return start;
}

void main() {
  int score = 0;
  String? line = null;
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    file.add(int.parse(line!));
  }
  //List<int> new_pos = List.generate(file.length, (i) => i);

  //Num first = Num(0, 0, file[0] null, null);
  //Num last = first;
  //for (int i = 1; i < file.length; ++i) {
  //  Num newer = Num(i, i, file[i], null, null);
  //  last.next = newer;
  //  last.orig_next = newer;
  //  last = newer;
  //}
  //last.next = first;
  //last.orig_next = first;

  Num p = last;
  for(int i = 0; i < file.length; ++i) {
    int val = p.next.val;
    if ((val % l) == 0) continue;



    p = p.orig_next;
  }


  print(score);
}
