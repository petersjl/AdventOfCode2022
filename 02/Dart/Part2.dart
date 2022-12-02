import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  Object input = File(filePath).readAsStringSync().splitNewLine().listMap<Pair<String,String>>((String line) {
    var parts = line.split(' ');
    return Pair<String,String>(parts[0], parts[1]);
  });
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var moves = parseInput() as List<Pair<String,String>>;
  int total = 0;
  for(var play in moves) total += score(play);
  print('This method results in a score of $total');
}

int score(Pair<String,String> play){
  switch(play.first){
    case 'A':
      switch(play.second){
        case 'X': return 3 + 0;
        case 'Y': return 1 + 3;
        case 'Z': return 2 + 6;
        default: return 0;
      }
    case 'B':
      switch(play.second){
        case 'X': return 1 + 0;
        case 'Y': return 2 + 3;
        case 'Z': return 3 + 6;
        default: return 0;
      }
    case 'C':
      switch(play.second){
        case 'X': return 2 + 0;
        case 'Y': return 3 + 3;
        case 'Z': return 1 + 6;
        default: return 0;
      }
    default : return 0;
  }
}