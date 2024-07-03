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

final dirs = {
  "U": Point(0, 1),
  "D": Point(0, -1),
  "L": Point(-1, 0),
  "R": Point(1, 0),
};


void main1() {
  print("Hello");
  String? line = null;
  int score = 0;
  final Map<Point, bool> vis = {};
  int x = 0;
  int y = 0;
  int tdx = 0;
  int tdy = 0;

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    //print(line);
    final parts = line!.split(" ");
    String dir =parts[0];
    int count = int.parse(parts[1]);
    final d = dirs[dir]!;
    for(int i = 0; i < count; i++) {
      x += d.x;
      y += d.y;
      tdx = tdx - d.x;
      tdy = tdy - d.y;
      if (tdx.abs() == 2) {
        tdx -= tdx.sign;
        tdy = 0;
      } else if (tdy.abs() == 2) {
        tdy -= tdy.sign;
        tdx = 0;
      }
      //if ((tdx + d.x).abs() > 1) { // Too far in x axis
      //  tdy = 0; // Towards the center if it wasn't
      //} else if ((tdy + d.y).abs() > 1) {
      //  tdx = 0;
      //} if (tdx == 0 && tdy == 0) { // on top
      //  tdx -= d.x;
      //  tdy -= d.y;
      //} else if ((tdx + d.x) == 0 && (tdx + d.y) == 0) { // go on top
      //  tdx = 0;
      //  tdy = 0;
      //} else if (tdx == 0 && d.x.abs() > 0) {
      //  tdx -= d.x;
      //} else if (tdy == 0 && d.y.abs() > 0) {
      //  tdy -= d.y;
      //}
      final tail = Point(x + tdx, y + tdy);
      if (!vis.containsKey(tail)) {
        vis[tail] = true;
        score++;
      }
    }
  }
  print(score);
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

List<Point> nextKnotInstructions(List<Point> instructions) {
  final head = Point(0,0);
  final td = Point(0,0);
  final List<Point> result = [];
  for(final ins in instructions) {
    assert(ins.x <= 1 && ins.y <= 1);
    final prev = Point(head.x + td.x, head.y + td.y);
    head.x += ins.x;
    head.y += ins.y;
    final magniture = ins.x.abs() + ins.y.abs();
    if (magniture == 1 ) {
      td.x -= ins.x;
      td.y -= ins.y;
      if (td.x.abs() == 2) {
        td.x -= td.x.sign;
        td.y = 0;
      }
      if (td.y.abs() == 2) {
        td.y -= td.y.sign;
        td.x = 0;
      }
    } else {
      assert(magniture == 2);
      final nx = td.x - ins.x;
      final ny = td.y - ins.y;
      if (nx.abs() < 2 && ny.abs() < 2){
        td.x -= ins.x;
        td.y -= ins.y;
      } else {
        if (nx == 0) td.x = 0;
        if (ny == 0) td.y = 0;
      }
    }
    assert(td.x <= 1 && td.y <= 1);
    final next = Point(head.x + td.x, head.y + td.y);
    final delta = Point(next.x - prev.x, next.y - prev.y);
    if(delta.x > 1 || delta.y > 1) {
      print(" d:$ins  $td  $prev -> $next");
    }
    assert(delta.x <= 1 && delta.y <= 1);

    if ((delta.x.abs() + delta.y.abs()) > 0) {
      result.add(delta);
    }
  }
  return result;
}

int countVisited(List<Point> instructions) {
  final head = Point(0,0);
  final Map<Point, bool> visited = {Point(0,0): true};
  int count = 1;
  for(final ins in instructions) {
    head.x += ins.x;
    head.y += ins.y;
    if (!visited.containsKey(head)) {
      visited[head.dup()] = true;
      count++;
    }
  }
  return count;
}

void main() {
  print("Hello");
  String? line = null;
  int score = 0;
  final Map<Point, bool> vis = {};

  List<Point> ins = [];
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(" ");
    String dir = parts[0];
    int count = int.parse(parts[1]);
    for(int i = 0; i < count; i++) {
      ins.add(dirs[dir]!.dup());
    }
  }
  for(int i = 0; i < 9; i++) {
    ins = nextKnotInstructions(ins);
    //print(ins);
    //print(countVisited(ins));
  }
  print(countVisited(ins));
}


void main_ignore() {
  print("Hello");
  String? line = null;
  int score = 0;
  final Map<Point, bool> vis = {};
  final head = Point(0,0);
  final knots = new List<Point>.generate(9, (i) => Point(0, 0));

  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    print(line);
    final parts = line!.split(" ");
    String dir =parts[0];
    int count = int.parse(parts[1]);
    for(int i = 0; i < count; i++) {
      final d = dirs[dir]!.dup();
      print("iter $i $head $d");
      var x = head.x;
      var y = head.y; // Previous node's previous pos
      head.x += d.x;
      head.y += d.y;
      var nx = head.x;
      var ny = head.y; // Previous node's new pos
      for (final k in knots) {
        final knot_pos = Point(x + k.x, y + k.y);
        var knx = k.x - d.x;
        var kny = k.y - d.y;
        if (knx.abs() == 2) {
          knx -= knx.sign;
          if (d.y == 0) kny = 0;
        }
        if (kny.abs() == 2 && d.x == 0) {
          kny -= kny.sign;
          if (d.x == 0) knx = 0;
        }
        //d.x = k.x - knx;
        //d.y = k.y - kny;
        k.x = knx;
        k.y = kny;
        print("new knot delta $k");
        assert(k.x.abs() <= 1 && k.y.abs() <= 1);

        var knot_new_pos = Point(nx + k.x, ny + k.y);
        d.x =  knot_new_pos.x - knot_pos.x;
        d.y =  knot_new_pos.y - knot_pos.y;
        print("pos old $knot_pos,  new $knot_new_pos");
        assert(d.x.abs() <= 1 && d.y.abs() <= 1);

        print("$knot_pos -> $knot_new_pos (nd=$d) $k");
        x = knot_pos.x;
        y = knot_pos.y;
        nx = knot_new_pos.x;
        ny = knot_new_pos.y;
      }
      print("knots $knots");

      final t = Point(x, y);
      if (!vis.containsKey(t)) {
        vis[t] = true;
        score++;
      }
    }
    print("x ${head.x} y ${head.y} tdx $knots");
    //break; //todo
  }
  print(score);
}
