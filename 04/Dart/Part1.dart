import 'dart:io';
import '../../DartUtils.dart';

void main() {
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1 / 1000} seconds');
}

Object parseInput([bool test = false]) {
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath)
      .readAsStringSync()
      .splitNewLine()
      .listMap<Pair<Pair<int, int>, Pair<int, int>>>((String line) {
    var parts = line.split(',');
    var elfOne = parts[0].split('-').listMap<int>((thing) => int.parse(thing));
    var elfTwo = parts[1].split('-').listMap<int>((thing) => int.parse(thing));
    return Pair(Pair(elfOne[0], elfOne[1]), Pair(elfTwo[0], elfTwo[1]));
  });
  return input;
}

// The main method of the puzzle solve
void solvePuzzle() {
  var pairs = parseInput() as List<Pair<Pair<int, int>, Pair<int, int>>>;
  int count = 0;
  for (var pair in pairs) if (encapsulates(pair.first, pair.second)) count++;
  print('Ranges encapsulated in their pair: $count');
}

bool encapsulates(Pair<int, int> first, Pair<int, int> second) {
  return (first.first <= second.first && first.second >= second.second) ||
      (second.first <= first.first && second.second >= first.second);
}
