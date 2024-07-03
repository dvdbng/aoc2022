import 'dart:convert';
import 'dart:io';

final A = 'A'.codeUnits[0];
final Z = 'Z'.codeUnits[0];
final a = 'a'.codeUnits[0];
final z = 'z'.codeUnits[0];

bool contains(int a1, int a2, int b1, int b2) {
  return a1 <= b1 && a2 >= b2;
}

bool intersects(int a1, int a2, int b1, int b2) {
  return !(b2 < a1 || b1 > a2);
}

void main() {
  print("Hello");
  String? line = null;
  int score = 0;
  final List<List<String>> stacks = [];
  List<String> curdir = [];
  final Map<String, int> sizes = {};
  final Map<String, bool> counted = {};
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final parts = line!.split(' ');
    if (parts[0] == '\$') {
      if (parts[1] == 'cd') {
        if (parts[2] == '/') {
          curdir = [];
        } else if (parts[2] == '..') {
          curdir.removeLast();
        } else {
          curdir.add(parts[2]);
        }
      }
    } else if (parts[0] == "dir") {

    } else {
      final file = parts[1];
      final fullpath = "${curdir.join("/")}/$file";
      final size = int.parse(parts[0]);
      if (counted.containsKey(fullpath)) {
        continue;
      }
      counted[fullpath] = true;
      for (int i = 0; i<curdir.length + 1; i++) {
        final dir = curdir.take(i).join("/");
        sizes[dir] = (sizes[dir] ?? 0) + size;
      }
    }
  }
  print(sizes);
  for(final entry in sizes.entries) {
    if (entry.value < 100000) score += entry.value;
  }
  print(score);
  final tofree = sizes[""]! - 40000000 ;
  int max = 700000000;
  for(final entry in sizes.entries) {
    if (entry.value > tofree && entry.value < max) {
      max = entry.value;
    }
  }
  print(max);

}
