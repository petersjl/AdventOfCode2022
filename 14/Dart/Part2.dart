import 'dart:io';
import 'dart:math';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  Point mins = Point(10000,10000);
  Point maxs = Point(-1,-1);
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<List<Point>>((String line) {
    return line.split(' -> ').listMap<Point>((String withComma) {
      var parts = withComma.split(',').listMap<int>((String num) => int.parse(num));
      if(parts[0] > maxs.x) maxs.x = parts[0];
      if(parts[0] < mins.x) mins.x = parts[0];
      if(parts[1] > maxs.y) maxs.y = parts[1];
      if(parts[1] < mins.y) mins.y = parts[1];
      return Point(parts[0], parts[1]);
    });
  });
  return [input, mins, maxs];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var parts = parseInput() as List;
  var lines = parts[0] as List<List<Point>>;
  var mins = parts[1] as Point;
  var maxs = parts[2] as Point;

  List<List<int>> map = List.generate(maxs.y + 1, (index) => List.generate(maxs.x - mins.x + 1, (index) => 0));
  map.add(List.generate(map[0].length, (index) => 0));
  map.add(List.generate(map[0].length, (index) => -1));
  for(var line in lines){
    drawLine(map, line, mins.x);
  }

  var dropped = dropSand(map, 500 - mins.x);
  // printMap(map);
  print('Dropped $dropped pieces of sand before the fell into the void');
}

int dropSand(List<List<int>> map, int dropX){
  int count = 0;
  Point sand = Point(dropX, 0);
  while(true){
    // Can it fall straight down
    if(map[sand.y + 1][sand.x] == 0){
      sand.y++;
      continue;
    }
    // Are we at the left edge of the map
    if(sand.x == 0) {
      padLeft(map);
      sand.x++;
      dropX++;
    }
    // Can it fall to the left
    if(map[sand.y + 1][sand.x - 1] == 0){
      sand.y++;
      sand.x--;
      continue;
    }
    // Are we at the right edge of the map
    if(sand.x == map[0].length - 1){
      padRight(map);
    }
    // Can it fall to the right
    if(map[sand.y + 1][sand.x + 1] == 0){
      sand.y++;
      sand.x++;
      continue;
    }
    // It can't move so stop and place
    map[sand.y][sand.x] = 1;
    count++;
    // Did we just block the entry point
    if(sand == Point(dropX, 0)) break;
    // Reset for the next drop
    sand = Point(dropX, 0);
  }
  return count;
}

void padLeft(List<List<int>> map){
  for(var line in map){
    line.insert(0, 0);
  }
  map[map.length - 1][0] = -1;
}

void padRight(List<List<int>> map){
  for(var line in map){
    line.add(0);
  }
  map[map.length - 1][map[0].length - 1] = -1;
}

void drawLine(List<List<int>> map, List<Point> instruction, int left){
  Point prev = instruction[0];
  for(int i = 1; i < instruction.length; ++i){
    Point cur = instruction[i];
    if(cur.x == prev.x){
      int x = cur.x - left;
      for(int j = min(cur.y, prev.y); j <= max(cur.y, prev.y); ++j){
        map[j][x] = -1;
      }
    }
    else{
      int y = cur.y;
      for(int j = min(cur.x, prev.x) - left; j <= max(cur.x, prev.x) - left; ++j){
        map[y][j] = -1;
      }
    }
    prev = cur;
  }
}

void printMap(List<List<int>> map){
  for(var line in map){
    var str = StringBuffer();
    for(var spot in line){
      if(spot == 0) str.write('.');
      else if(spot == -1) str.write('#');
      else if(spot == 1) str.write('O');
      else str.write('X');
    }
    print(str);
  }
}