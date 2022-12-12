import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput2.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<List<String>>((String line) => line.split(' '));
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var instructions = parseInput() as List<List<String>>;
  Rope rope = Rope(10);
  Set<Point> seen = {};
  for(var line in instructions){
    for(int i = 0; i < int.parse(line[1]); ++i){
      rope.move(line[0]);
      seen.add(Point.clone(rope.tail));
    }
  }
  print('The tail has seen ${seen.length} locations');
}

class Rope{
  List<Point> _knots;
  Point get head => _knots[0];
  Point get tail => _knots[_knots.length-1];

  Rope(int length):_knots = List.generate(length, (index) => Point(0,0));

  void move(String direction){
    moveHead(head, direction);
    for(int i = 1; i < _knots.length; ++i){
      fixTail(_knots[i], _knots[i-1]);
    }
  }
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