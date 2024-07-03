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

final Map<String, int> pressure = {};
final Map<String, List<String>> next = {};
final Map<String, Map<String, int>> distances = {};
final Set<String> opened = new Set();

//int dfs(String origin, int time_left) {
//  int best = 0;
//  if (time_left == 0) return 0;
//  if (!opened.contains(origin) && pressure[origin] != 0) {
//    opened.add(origin);
//    best = max(
//      best,
//      pressure[origin] * (time_left - 1) + dfs(next, pressure, opened, origin, time_left - 1)
//    );
//    opened.remove(origin);
//  }
//  for (final succ in next[origin]) {
//    best = max(best, dfs(next, pressure, opened, succ, time_left - 1));
//  }
//  return best;
//}

int search(source, time) {
  // best = (time - nexts[0].value - 1) * pressure[nexts[0].key];
  // besti = nexts[0].key;
  // for (possible_next in nexts) {
  //   if (thisval > best) {
  //     best = thisval;
  //     besti = possible_next.key;
  //   }
  // }
  // if (best == 0) return 0;
  int best = 0;

  for (final succ in distances[source]!.entries) {
    if (succ.value > time - 1) continue;
    if (opened.contains(succ.key)) continue;
    if (pressure[succ.key] == 0) continue;

    opened.add(succ.key);
    final thisval = (time - succ.value - 1) * pressure[succ.key];
    best = max(best, thisval + search(succ.key, time - distances[source]![succ.key] - 1));
    opened.remove(succ.key);
  }
  return best;
}

int search2(source1, source2, time_left_2, time) {
  // best = (time - nexts[0].value - 1) * pressure[nexts[0].key];
  // besti = nexts[0].key;
  // for (possible_next in nexts) {
  //   if (thisval > best) {
  //     best = thisval;
  //     besti = possible_next.key;
  //   }
  // }
  // if (best == 0) return 0;
  if (time_left_2 < 0) {
    print("$source1, $source2, $time");
    assert(false);
  }
  int best = 0;

  for (final succ in distances[source1]!.entries) {
    if (succ.value > time - 1) continue;
    if (opened.contains(succ.key)) continue;
    if (pressure[succ.key] == 0) continue;

    final thisval = (time - succ.value - 1) * pressure[succ.key];
    opened.add(succ.key);
    if ((succ.value + 1) < time_left_2) {
      final times = succ.value + 1;
      best = max(best, thisval + search2(succ.key, source2, time_left_2 - times, time - times));
    } else {
      final times = time_left_2;
      best = max(best, thisval + search2(source2, succ.key, succ.value + 1 - times, time - times));
    }
    opened.remove(succ.key);
  }
  return best;
}

String distkey(String a, String b) {
  return "$a:$b";
}

void dfs_distances() {
  for (final entry in next.entries) {
    distances[entry.key] = { entry.key: 0 };
    for (final succ in entry.value) {
      distances[entry.key]![succ] = 1;
    }
  }
  while (true) {
    for (final start in next.keys) {
      final ds = distances[start]!;
      for (final mid_entry in List.from(ds.entries)) {
        for (final end in next[mid_entry.key]!) {
          ds[end] = min(ds[end] ?? 9999, mid_entry.value + 1);
        }
      }
    }
    if (distances.values.every((m) => m.length == next.length)) break;
    for (final k in next.keys) {
      if (pressure[k] > 0 || k == "AA") continue;
      for (final d in distances.values) {
        d.remove(k);
      }
      distances.remove(k);
    }
  }
}

void main() {
  int score = 0;
  String? line = null;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(new RegExp("[ =:,;]+"));
    final source = parts[1];
    final flow = int.parse(parts[5]);
    final connections = parts.sublist(10);
    pressure[source] = flow;
    next[source] = connections;
  }
  dfs_distances();
  score = search2("AA", "AA", 0, 26);
  print(score);
}
