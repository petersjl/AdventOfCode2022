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
  var visibility = List.generate(map.length, (row) => 
    List.generate(map[0].length, (col) => 
      row == 0 || col == 0 || row == map.length -1 || col == map[0].length -1));
  checkFromUp(map, visibility);
  checkFromDown(map, visibility);
  checkFromLeft(map, visibility);
  checkFromRight(map, visibility);
  print('Number of trees visible: ${countVisible(visibility)}');
}

void checkFromUp(List<List<int>> map, List<List<bool>> visibility){
  for(int x = 1; x < map[0].length - 1; ++x){
    int currentHighest = map[0][x];
    for(int y = 1; y < map.length - 1; ++y){
      if(map[y][x] > currentHighest){
        visibility[y][x] = true;
        currentHighest = map[y][x];
      }
    }
  }
}

void checkFromDown(List<List<int>> map, List<List<bool>> visibility){
  for(int x = 1; x < map[0].length - 1; ++x){
    int currentHighest = map[map.length-1][x];
    for(int y = map.length - 2; y > 0 - 1; --y){
      if(map[y][x] > currentHighest){
        visibility[y][x] = true;
        currentHighest = map[y][x];
      }
    }
  }
}

void checkFromLeft(List<List<int>> map, List<List<bool>> visibility){
  for(int y = 1; y < map.length -1; ++y){
    int currentHighest = map[y][0];
    for(int x = 1; x < map[0].length - 1; ++x){
      if(map[y][x] > currentHighest){
        visibility[y][x] = true;
        currentHighest = map[y][x];
      }
    }
  }
}

void checkFromRight(List<List<int>> map, List<List<bool>> visibility){
  for(int y = 1; y < map.length -1; ++y){
    int currentHighest = map[y][map[0].length-1];
    for(int x = map[0].length - 1; x > 0; --x){
      if(map[y][x] > currentHighest){
        visibility[y][x] = true;
        currentHighest = map[y][x];
      }
    }
  }
}

int countVisible(List<List<bool>> vis){
  int count = 0;
  for(var line in vis)
    for(var tree in line)
      if(tree) count++;
  return count;
}

void printHeights(List<List<int>> map){
  for(var line in map){
    var buf = StringBuffer();
    for(var tree in line) buf.write(tree);
    print(buf);
  }
}

void printVisibility(List<List<bool>> vis){
  for(var line in vis){
    var buf = StringBuffer();
    for(var tree in line) buf.write(tree ? 'A' : '-');
    print(buf);
  }
}