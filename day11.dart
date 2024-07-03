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

class Monkey {
  List<int> items;
  int Function(int) op;
  int Function(int) next;
  int inspections = 0;
  Monkey({required this.items, required this.op, required this.next});
}

final monkeys = [
Monkey(
  items: [75, 63],
  op:  (old) => old * 3,
  next: (i) => (i % 11) == 0 ?  7 : 2
),Monkey(
  items: [65, 79, 98, 77, 56, 54, 83, 94],
   op: (old) => old + 3,
  next: (i) => (i % 2) == 0 ?  2 : 0

),Monkey(
  items: [66],
   op: (old) => old + 5,
  next: (i) => (i % 5) == 0 ?  7 : 5

),Monkey(
  items: [51, 89, 90],
   op: (old) => old * 19,
  next: (i) => (i % 7) == 0 ?  6 : 4

),Monkey(
  items: [75, 94, 66, 90, 77, 82, 61],
   op: (old) => old + 1,
  next: (i) => (i % 17) == 0 ?  6 : 1

),Monkey(
  items: [53, 76, 59, 92, 95],
   op: (old) => old + 2,
  next: (i) => (i % 19) == 0 ?  4 : 3

),Monkey(
  items: [81, 61, 75, 89, 70, 92],
  op: (old) => old * old,
  next: (i) => (i % 3) == 0 ?  0 : 1

),Monkey(
  items: [81, 86, 62, 87],
   op: (old) => old + 8,
  next: (i) => (i % 13) == 0 ?  3 : 5
)];
int mod = 11*2*5*7*17*19*3*13;


void main1() {
  for (int i = 0; i < 20; ++i) {
    for (final monkey in monkeys) {
      final olditems = monkey.items;
      monkey.items = [];
      for (var worry in olditems) {
        monkey.inspections++;
        worry = monkey.op(worry);
        worry = worry ~/ 3;
        int next = monkey.next(worry);
        monkeys[next].items.add(worry);
      }
    }
  }
  monkeys.sort((a, b) => b.inspections.compareTo(a.inspections));
  print(monkeys[0].inspections * monkeys[1].inspections);
}


void main() {
  for (int i = 0; i < 10000; ++i) {
    for (final monkey in monkeys) {
      final olditems = monkey.items;
      monkey.items = [];
      for (var worry in olditems) {
        monkey.inspections++;
        int nworry = monkey.op(worry) % mod;
        int next = monkey.next(nworry);
        monkeys[next].items.add(nworry);
      }
    }
  }
  monkeys.sort((a, b) => b.inspections.compareTo(a.inspections));
  print(monkeys[0].inspections * monkeys[1].inspections);
}
