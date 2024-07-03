import 'dart:convert';
import 'dart:math';
import 'dart:collection';
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



void bfs(List<List<int>> map, List<List<int>> vis, Point p, Queue<Point> queue) {
  int h = map[p.y][p.x];
  int turn = vis[p.y][p.x];
  List<Point> tovisit = [];
  for (int nx = max(p.x - 1, 0); nx <= min(p.x + 1, map[0].length - 1); nx++) {
    for (int ny = max(p.y - 1, 0); ny <= min(p.y + 1, map.length - 1); ny++) {
      if (nx == 0 && ny == 0) continue;
      if (nx != p.x && ny != p.y) continue;
      if (map[ny][nx] > h + 1) continue;
      if (vis[ny][nx] >= 0) continue;
      vis[ny][nx] = turn + 1;
      queue.addLast(Point(nx, ny));
    }
  }
  //for (final p in tovisit) {
  //  bfs(map, vis, p);
  //}
}

void main1() {
  final List<List<int>> map = [];
  final start = Point(0, 0);
  final end = Point(0, 0);
  final List<List<int>> vis = [];
  String? line = null;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final row = line!.codeUnits.toList();
    final startIdx = row.indexOf("S".codeUnits[0]);
    final endIdx = row.indexOf("E".codeUnits[0]);
    if (startIdx >= 0) {
      row[startIdx] = a;
      start.y = map.length;
      start.x = startIdx;
    }
    if (endIdx >= 0) {
      row[endIdx] = z;
      end.y = map.length;
      end.x = endIdx;
    }
    map.add(row);
    vis.add(row.map((_) => -1).toList());
  }
  final queue = Queue<Point>();
  vis[start.y][start.x] = 0;
  queue.addLast(start);
  while(!queue.isEmpty) {
    bfs(map, vis, queue.removeFirst(), queue);
  }
  print(vis.map((l) => l.map((n) => n.toString().padLeft(3, "0") ).join(" ")).join("\n"));
  print(vis[end.y][end.x]);
}


void main() {
  final List<List<int>> map = [];
  final start = Point(0, 0);
  final end = Point(0, 0);
  final List<List<int>> vis = [];
  String? line = null;
  final queue = Queue<Point>();

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final row = line!.codeUnits.toList();
    final startIdx = row.indexOf("S".codeUnits[0]);
    final endIdx = row.indexOf("E".codeUnits[0]);
    if (startIdx >= 0) {
      row[startIdx] = a;
      start.y = map.length;
      start.x = startIdx;
    }
    if (endIdx >= 0) {
      row[endIdx] = z;
      end.y = map.length;
      end.x = endIdx;
    }
    vis.add(row.map((_) => -1).toList());
    for (int x = 0; x < row.length; x++) {
      if (row[x] == a) {
        queue.addLast(Point(x, map.length));
        vis[map.length][x] = 0;
      }
    }
    map.add(row);
  }
  vis[start.y][start.x] = 0;
  while(!queue.isEmpty) {
    bfs(map, vis, queue.removeFirst(), queue);
  }
  print(vis.map((l) => l.map((n) => n.toString().padLeft(3, "0") ).join(" ")).join("\n"));
  print(vis[end.y][end.x]);
}
