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

Point parsePoint(String s) {
  print(s);
  final parts = s.split(",");
  return Point(int.parse(parts[0]), int.parse(parts[1]));
}

int air = 0;
int rock = 1;
int sand = 2;

void main1() {
  final List<List<int>> map = List.generate(1000, (_) => List.generate(1000, (_) => air));
  final start = Point(500, 0);
  String? line = null;
  int score = 0;
  int maxy = 0;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(" -> ");
    var prev = parsePoint(parts[0]);
    maxy = max(prev.y, maxy);
    for (int i = 1; i < parts.length; ++i) {
      var next = parsePoint(parts[i]);
      maxy = max(next.y, maxy);
      if (next.x == prev.x) {
        for(int y = min(next.y, prev.y); y <= max(next.y, prev.y); ++y) {
          map[y][next.x] = rock;
        }
      } else {
        print("$prev -> $next");
        assert(next.y == prev.y);
        for(int x = min(next.x, prev.x); x <= max(next.x, prev.x); ++x) {
          map[next.y][x] = rock;
        }
      }
      prev = next;
    }
  }


  out:
  while (true) {
    var pos = start.dup();
    while(true) {
      if (pos.y >= map.length - 1 || pos.x < 0 || pos.x > map.length) {
        print(score);
        break out;
      } else if (map[pos.y + 1][pos.x] == air) {
        pos.y++;
      } else if (map[pos.y + 1][pos.x - 1] == air) {
        pos.y++;
        pos.x--;
      } else if (map[pos.y + 1][pos.x + 1] == air) {
        pos.y++;
        pos.x++;
      } else {
        map[pos.y][pos.x] = sand;
        score++;
        break;
      }
    }
  }
  //print(map.map((l) => l.join('')).join('\n'));


  print(score);
}


void main() {
  final List<List<int>> map = List.generate(1000, (_) => List.generate(1000, (_) => air));
  final start = Point(500, 0);
  String? line = null;
  int score = 0;
  int maxy = 0;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(" -> ");
    var prev = parsePoint(parts[0]);
    maxy = max(prev.y, maxy);
    for (int i = 1; i < parts.length; ++i) {
      var next = parsePoint(parts[i]);
      maxy = max(next.y, maxy);
      if (next.x == prev.x) {
        for(int y = min(next.y, prev.y); y <= max(next.y, prev.y); ++y) {
          map[y][next.x] = rock;
        }
      } else {
        print("$prev -> $next");
        assert(next.y == prev.y);
        for(int x = min(next.x, prev.x); x <= max(next.x, prev.x); ++x) {
          map[next.y][x] = rock;
        }
      }
      prev = next;
    }
  }
  for (int x = 0; x < map.length; ++x) {
    map[maxy + 2][x] = rock;
  }


  out:
  while (true) {
    var pos = start.dup();
    while(true) {
      if (pos.y >= map.length - 1 || pos.x < 0 || pos.x > map.length) {
        print(score);
        break out;
      } else if (map[pos.y + 1][pos.x] == air) {
        pos.y++;
      } else if (map[pos.y + 1][pos.x - 1] == air) {
        pos.y++;
        pos.x--;
      } else if (map[pos.y + 1][pos.x + 1] == air) {
        pos.y++;
        pos.x++;
      } else {
        map[pos.y][pos.x] = sand;
        score++;
        if (pos == start) break out;
        break;
      }
    }
  }
  //print(map.map((l) => l.join('')).join('\n'));


  print(score);
}
