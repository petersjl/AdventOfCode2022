import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine().listMap<List<String>>((String line) => line.characters);
  Point start = Point(-1,-1);
  Point dest = Point(-1,-1);
  List<List<int>> heights = List.generate(input.length, (index) => List.generate(input[0].length ,(i) => 1000));
  for(var row = 0; row < input.length; ++row){
    for(var col = 0; col < input[0].length; ++col){
      var char = input[row][col];
      if(char =='S'){
        start = Point(col, row);
        heights[row][col] = 'a'.codeUnitAt(0);
      }
      else if(char == 'E'){
        dest = Point(col,row);
        heights[row][col] = 'z'.codeUnitAt(0);
      }
      else{
        heights[row][col] = char.codeUnitAt(0);
      }
    }
  }
  return [start,dest,heights];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var parts = parseInput() as List;
  Point start = parts[0];
  Point dest = parts[1];
  List<List<int>> heights = parts[2];
  Set<Point> seen = {};
  var queue = PriorityQueue<Pair<int,Node<Point>>>((queueItem, toInsert) => queueItem.first - toInsert.first);

  seen.add(start);
  queue.enqueue(Pair(mdist(start, dest), Node(start)));
  Node<Point>? found;
  while(queue.length > 0){
    var current = queue.dequeue();
    var curval = current.second.value;
    if(curval.x > 0){
      if(heights[curval.y][curval.x - 1] <= heights[curval.y][curval.x] + 1){
        Point np = Point(curval.x - 1, curval.y);
        var nNode = Node(np, current.second);
        if(np == dest){
          found = nNode;
          break;
        }
        if(seen.add(np))
          queue.enqueue(Pair(mdist(dest, np), nNode));
      }
    }
    if(curval.x < heights[0].length - 1){
      if(heights[curval.y][curval.x + 1] <= heights[curval.y][curval.x] + 1){
        Point np = Point(curval.x + 1, curval.y);
        var nNode = Node(np, current.second);
        if(np == dest){
          found = nNode;
          break;
        }
        if(seen.add(np))
          queue.enqueue(Pair(mdist(dest, np), nNode));
      }
    }
    if(curval.y > 0){
      if(heights[curval.y - 1][curval.x] <= heights[curval.y][curval.x] + 1){
        Point np = Point(curval.x, curval.y - 1);
        var nNode = Node(np, current.second);
        if(np == dest){
          found = nNode;
          break;
        }
        if(seen.add(np))
          queue.enqueue(Pair(mdist(dest, np), nNode));
      }
    }
    if(curval.y < heights.length -1){
      if(heights[curval.y + 1][curval.x] <= heights[curval.y][curval.x] + 1){
        Point np = Point(curval.x, curval.y + 1);
        var nNode = Node(np, current.second);
        if(np == dest){
          found = nNode;
          break;
        }
        if(seen.add(np))
          queue.enqueue(Pair(mdist(dest, np), nNode));
      }
    }
  }
  if(found == null) print('No path to destination');
  else{
    int dist = 0;
    while(found!.next != null){
      dist++;
      found = found.next;
    }
    print('You reach the destination in $dist steps');
  }
}

int mdist(Point first, Point second) => (first.x - second.x).abs() + (first.y - second.y).abs();

class Node<T>{
  T value;
  Node<T>? next;
  Node(this.value,[this.next]);
}