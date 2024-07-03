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


Range? intersectionWithLine(Point p, int h, int d) {
  int hdiff = d - p.dist(Point(p.x, h));
  if (hdiff < 0) return null;
  return Range(p.x - hdiff, p.x + hdiff);
}


void simplify(List<Range> ranges) {
  bool changed = true;
  while (changed) {
    changed = false;
    outerLoop:
    for (int i = 0; i < ranges.length - 1; ++i) {
      for (int j = i + 1; j < ranges.length; ++j) {
        assert(i != j);
        if (ranges[i].mergeable(ranges[j])) {
          ranges[i] = ranges[i].merge(ranges[j]);
          ranges.removeAt(j);
          changed = true;
          break outerLoop;
        }
      }
    }
  }
}

void main1() {
  final List<List<int>> map = [];
  final start = Point(0, 0);
  final end = Point(0, 0);
  final List<List<int>> vis = [];
  String? line = null;
  final queue = Queue<Point>();
  assert(intersectionWithLine(Point(0,0), 0, 5)!.size() == 10);

  int score = 0;
  final Map<Point, int> known = {};
  final h = 2000000;
  int baconsInH = 0;

  List<Range> ranges = [];

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(new RegExp("[ =:,]"));
    final pos = Point(int.parse(parts[3]), int.parse(parts[6]));
    final baconPos = Point(int.parse(parts[13]), int.parse(parts[16]));
    final radius = baconPos.dist(pos);
    known[pos] = radius;
    if (pos.y == h) baconsInH++;
    final range = intersectionWithLine(pos, h, radius);
    if (range != null) {
      ranges.add(range);
      simplify(ranges);
    }
  }

  print(ranges.map((r) => r.size()).fold(0, (a, b) => a + b) - baconsInH);

  print(score);
}


void main() {
  final List<List<int>> map = [];
  final start = Point(0, 0);
  final end = Point(0, 0);
  final List<List<int>> vis = [];
  String? line = null;
  final queue = Queue<Point>();
  assert(intersectionWithLine(Point(0,0), 0, 5)!.size() == 10);

  int score = 0;
  final Map<Point, int> known = {};
  final maxc = 4000000;
  final area = Range(0, maxc);

  List<List<Range>> covered = List.generate(maxc + 1, (_) => []);

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(new RegExp("[ =:,]"));
    final pos = Point(int.parse(parts[3]), int.parse(parts[6]));
    final baconPos = Point(int.parse(parts[13]), int.parse(parts[16]));
    final radius = baconPos.dist(pos);
    known[pos] = radius;
    print("$radius, $pos");
    for (int y = max(0, pos.y - radius); y < min(maxc, pos.y + radius); ++y) {
      if (!covered[y].isEmpty && covered[y][0] == area) continue;
      final range = intersectionWithLine(pos, y, radius);
      if (range != null) {
        covered[y].add(range);
        simplify(covered[y]);
        covered[y][0].clamp(area);
      }
    }
  }
  for (int y = 0; y <= maxc; ++y) {
    if (!covered[y].isEmpty && covered[y][0] == area) continue;
    print(y);
    print(covered[y]);
  }


  print(score);
}
