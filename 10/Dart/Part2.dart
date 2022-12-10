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
  List<String> screen = [];
  for (var line in instructions) {
    int cCount;
    int toAdd = 0;
    if (line[0] == 'noop') cCount = 1;
    else {
      cCount = 2;
      toAdd = int.parse(line[1]);
    }
    for(int i  = 0; i < cCount; ++i){
      var rowDrawPos = cycle % 40;
      screen.add(x-1 <= rowDrawPos && rowDrawPos <= x+1 ? '#' : '.');
      cycle++;
    }
    x += toAdd;
  }
  var str = StringBuffer();
  int index = 0;
  for(var char in screen){
    str.write(char);
    index++;
    if(index % 40 == 0) str.write('\n');
  }
  print('Screen displays:');
  print(str);
}
