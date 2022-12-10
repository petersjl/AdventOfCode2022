import 'dart:io';
import '../../DartUtils.dart';

void main() {
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1 / 1000} seconds');
}

Object parseInput([bool test = false]) {
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<List<String>>((String line) => line.split(' '));
  return input;
}

// The main method of the puzzle solve
void solvePuzzle() {
  var instructions = parseInput() as List<List<String>>;
  int x = 1;
  int cycle = 0;
  int total = 0;
  for (var line in instructions) {
    int cCount;
    int toAdd = 0;
    if (line[0] == 'noop') cCount = 1;
    else {
      cCount = 2;
      toAdd = int.parse(line[1]);
    }
    for(int i  = 0; i < cCount; ++i){
      cycle++;
      if((cycle - 20) % 40 == 0 && cycle < 221) {
        var n = x * cycle;
        print('Cycle $cycle gives $n');
        total += n;
      }
    }
    x += toAdd;
  }
  print('Total after $cycle cycles is $total');
}
