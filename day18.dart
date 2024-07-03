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


void main() {
  int score = 0;
  String? line = null;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(",").map((s) => int.parse(s)).toList();
    map.add(Point3(parts[0],parts[1],parts[2]));
  }
  Range xr = Range(map.first.x, map.first.x);
  Range yr = Range(map.first.y, map.first.y);
  Range zr = Range(map.first.z, map.first.z);
  for (final point in map) {
    xr.s = min(xr.s, point.x);
    xr.e = max(xr.e, point.x);
    yr.s = min(yr.s, point.y);
    yr.e = max(yr.e, point.y);
    zr.s = min(zr.s, point.z);
    zr.e = max(zr.e, point.z);
  }
  xr.s -= 1;
  yr.s -= 1;
  zr.s -= 1;
  xr.e += 1;
  yr.e += 1;
  zr.e += 1;

  Set<Point3> outside = new Set();
  List<Point3> queue = [Point3(xr.s, yr.s, zr.s)];
  while (!queue.isEmpty) {
    final p = queue.removeLast();
    if (map.contains(p)) continue;
    if (!xr.contains(p.x) || !yr.contains(p.y) || !zr.contains(p.z)) continue;
    if (outside.add(p)) {
      queue.addAll(p.neigh());
    }
  }

  for (final point in map) {
    for (final n in point.neigh()) {
      if (!map.contains(n) && outside.contains(n)) score++;
    }
  }
  print(score);
}
