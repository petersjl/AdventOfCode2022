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
  var test = false;
  var input = parseInput(test) as List;
  Pair<int, int> bounds = Pair(0, test ? 20 : 4000000);
  var targetLine = input[0];
  var pairs = input[1] as List<Pair<Point,Point>>;
  var mins = input[2] as Point;
  var maxs = input[3] as Point;
  List<Point> beacons = [];
  List<Pair<Point, int>> domains = pairs.listMap<Pair<Point,int>>((Pair<Point,Point> pair) {
    beacons.add(pair.second);
    return Pair(pair.first, mdist(pair.first, pair.second));
  });
  Point? found;
  for(int i = 0; i < domains.length && found == null; ++i){
    var dom = domains[i];
    for(int x = max(bounds.first, dom.first.x - dom.second - 1);
        x <= min(bounds.second, dom.first.x + dom.second + 1) && found == null; ++x){
      var ydist = dom.second - (dom.first.x - x).abs() + 1;
      if(dom.first.y + ydist <= bounds.second){
        var check = Point(x,dom.first.y + ydist);
        var plausible = true;
        for(var dom in domains){
          var checkdist = mdist(check, dom.first);
          if(checkdist <= dom.second){
            plausible = false;
            break;
          }
        }
        if(!plausible) continue;
        if(!beacons.contains(check)) found = check;
      }
      if(dom.first.y - ydist <= bounds.second){
        var check = Point(x,dom.first.y - ydist);
        var plausible = true;
        for(var dom in domains){
          var checkdist = mdist(check, dom.first);
          if(checkdist <= dom.second){
            plausible = false;
            break;
          }
        }
        if(!plausible) continue;
        if(!beacons.contains(check)) found = check;
      }
    }
  }
  if(found == null) print('No viable point for the beacon');
  else print('Point $found makes tuning frequency ${(found.x * 4000000) + found.y}');
}

bool inBounds(Point check, Pair bounds) => 
  bounds.first <= check.x &&
  check.x <= bounds.second &&
  bounds.first <= check.y &&
  check.y <= bounds.second;

int mdist(Point first, Point second) => (first.x - second.x).abs() + (first.y - second.y).abs();