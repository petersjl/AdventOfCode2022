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
  List<Set<String>> input = File(filePath)
      .readAsStringSync()
      .splitNewLine()
      .listMap<Set<String>>((String line) => Set<String>.from(line.characters));
  return input;
}

// The main method of the puzzle solve
void solvePuzzle() {
  var bags = parseInput() as List<Set<String>>;
  int count = 0;
  for (int i = 2; i < bags.length; i += 3) {
    var unique = bags[i - 2];
    Set<String> inTwo = {};
    for (var item in bags[i - 1]) {
      if (unique.add(item)) continue;
      inTwo.add(item);
    }
    for (var item in bags[i]) {
      if (inTwo.add(item)) continue;
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
