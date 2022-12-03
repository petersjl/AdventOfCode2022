import 'dart:io';
import '../../DartUtils.dart';

int a = 'a'.codeUnitAt(0) - 1;
int A = 'A'.codeUnitAt(0) - 27;

void main() {
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1 / 1000} seconds');
}

Object parseInput([bool test = false]) {
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  List<String> input = File(filePath).readAsStringSync().splitNewLine();
  var bags = input.listMap<Pair<Set<String>, Set<String>>>((String line) {
    var first = Set<String>.from(line.substring(0, line.length ~/ 2).characters);
    var second = Set<String>.from(line.substring(line.length ~/ 2, line.length).characters);
    return Pair(first, second);
  });
  return bags;
}

// The main method of the puzzle solve
void solvePuzzle() {
  var bags = parseInput() as List<Pair<Set<String>, Set<String>>>;
  int count = 0;
  for (var bag in bags) {
    for (var item in bag.second) {
      if (bag.first.add(item)) continue;
      count += itemValue(item);
    }
  }
  print('The sum of priorities is ${count}');
}

int itemValue(String item) {
  int ascii = item.codeUnitAt(0);
  if (ascii < a)
    return ascii - A;
  else
    return ascii - a;
}
