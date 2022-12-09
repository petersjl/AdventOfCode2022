import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<List<String>>((String line) => line.split(' '));
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var instructions = parseInput() as List<List<String>>;
  Point head = Point(0,0);
  Point tail = Point(0,0);
  Set<Point> seen = {};
  for(var line in instructions){
    // print(line);
    for(int i = 0; i < int.parse(line[1]); ++i){
      moveHead(head, line[0]);
      fixTail(tail, head);
      seen.add(Point.clone(tail));
      // print('$head $tail');
    }
  }
  print('The tail has seen ${seen.length} locations');
}

void moveHead(Point head, String direction){
  switch(direction){
    case 'U': head.y += 1; break;
    case 'D': head.y -= 1; break;
    case 'L': head.x -= 1; break;
    case 'R': head.x += 1; break;
  }
}

void fixTail(Point tail, Point head){
  var xdif = (head.x - tail.x);
  var ydif = (head.y - tail.y);
  if(xdif.abs() > 1 || ydif.abs() > 1){
    tail.x += xdif.sign;
    tail.y += ydif.sign;
  }
}