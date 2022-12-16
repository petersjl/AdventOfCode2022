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
  var input = File(filePath).readAsStringSync().splitNewLine();
  var targetLine = int.parse(input.removeAt(0));
  Point mins = Point(1000000,1000000);
  Point maxs = Point(-1000000,-1000000);
  var pairs = input.listMap<Pair<Point,Point>>((String line) {
    var parts = line.split(new RegExp('x=|, y=|:'));
    var sensor = Point(int.parse(parts[1]),int.parse(parts[2]));
    var beacon = Point(int.parse(parts[4]), int.parse(parts[5]));
    mins.x = min(mins.x, min(sensor.x, beacon.x));
    mins.y = min(mins.x, min(sensor.y, beacon.y));
    maxs.x = max(maxs.x, max(sensor.x, beacon.x));
    maxs.y = max(maxs.y, max(sensor.y, beacon.y));
    return Pair(sensor,beacon);
  });
  return [targetLine, pairs, mins, maxs];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var input = parseInput() as List;
  var targetLine = input[0];
  var pairs = input[1] as List<Pair<Point,Point>>;
  var min = input[2] as Point;
  var max = input[3] as Point;
  List<bool> availability = List.generate(max.x - min.x + 40000001, (index) => true);
  for(var pair in pairs){
    int dist = mdist(pair.first, pair.second);
    for(int i = pair.first.x - dist; i <= pair.first.x + dist; ++i){
      var onLine = Point(i, targetLine);
      var d2 = mdist(pair.first, onLine);
      // If the spot is within that distance and not already a beacon, it can not have a beacon
      if(d2 <= dist && !(pair.second.y == targetLine && pair.second.x == i + min.x)) {
        availability[i - (min.x - 20000000)] = false;
      }
    }
  }
  int count = 0;
  availability.forEach((element) {if(!element) count++;});
  print('Beacons are blocked in $count spaces at line $targetLine');
}

int mdist(Point first, Point second) => (first.x - second.x).abs() + (first.y - second.y).abs();