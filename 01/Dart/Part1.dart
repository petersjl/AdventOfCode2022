import 'dart:io';
import '../../DartUtils.dart';

void main() {
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1 / 1000} seconds');
}

Object parseInput([bool test = false]) {
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  List<List<String>> elves = File(filePath)
      .readAsStringSync()
      .split('\r\n\r\n')
      .listMap<List<String>>((entry) => entry.split('\r\n'));
  List<List<int>> list = [];
  for (List<String> e in elves) {
    list.add(e.listMap<int>((entry) => int.parse(entry)));
  }
  return list;
}

// The main method of the puzzle solve
void solvePuzzle() {
  var elves = parseInput() as List<List<int>>;
  int max = 0;
  for (List<int> e in elves) {
    int count = 0;
    for (int num in e) {
      count += num;
    }
    if (count > max) max = count;
  }
  print('Max calories is $max');
}
