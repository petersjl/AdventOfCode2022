import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<List<int>>((String line) {
    return line.characters.listMap<int>((String char) => int.parse(char));
  });
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var map = parseInput() as List<List<int>>;
  var scores = List.generate(map.length, (row) => 
    List.generate(map[0].length, (col) => 1));
  checkFromUp(map, scores);
  checkFromDown(map, scores);
  checkFromLeft(map, scores);
  checkFromRight(map, scores);
  print('Best scenic score is ${findBest(scores)}');
}

void checkFromUp(List<List<int>> map, List<List<int>> scores){
  for(int x = 1; x < map[0].length - 1; ++x){
    var watch = generateWatch();
    for(int y = 0; y < map.length; ++y){
      increment(watch);
      scores[y][x] *= watch[map[y][x]];
      zeroTo(watch, map[y][x]);
    }
  }
}

void checkFromDown(List<List<int>> map, List<List<int>> scores){
  for(int x = 1; x < map[0].length - 1; ++x){
    var watch = generateWatch();
    for(int y = map.length - 1; y >= 0; --y){
      increment(watch);
      scores[y][x] *= watch[map[y][x]];
      zeroTo(watch, map[y][x]);
    }
  }
}

void checkFromLeft(List<List<int>> map, List<List<int>> scores){
  for(int y = 1; y < map.length -1; ++y){
    var watch = generateWatch();
    for(int x = 0; x < map[0].length; ++x){
      increment(watch);
      scores[y][x] *= watch[map[y][x]];
      zeroTo(watch, map[y][x]);
    }
  }
}

void checkFromRight(List<List<int>> map, List<List<int>> scores){
  for(int y = 1; y < map.length -1; ++y){
    var watch = generateWatch();
    for(int x = map[0].length - 1; x >= 0; --x){
      increment(watch);
      scores[y][x] *= watch[map[y][x]];
      zeroTo(watch, map[y][x]);
    }
  }
}

List<int> generateWatch(){
  return List.generate(10, (index) => -1);
}

void increment(List<int> watch){
  for(int i = 0; i < 10; ++i) watch[i]++;
}

void zeroTo(List<int> watch, int pos){
  for(int i = 0; i <= pos; ++i) watch[i] = 0;
}

void printHeights(List<List<int>> map){
  for(var line in map){
    var buf = StringBuffer();
    for(var tree in line) buf.write(tree);
    print(buf);
  }
}

int findBest(List<List<int>> scores){
  int best = 0;
  for(int y = 1; y < scores.length - 1; ++y){
    var line = scores[y];
    for(int x = 1; x < line.length - 1; ++x){
      if(line[x] > best) best = line[x];
    }
  }
  return best;
}