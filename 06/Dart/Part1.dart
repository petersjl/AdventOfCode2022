import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync();
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var input = parseInput() as String;
  String one = input[0];
  String two = input[1];
  String three = input[2];
  int i = 3;
  while(i < input.length){
    String four = input[i];
    if(one != two && one != three && one != four && two != three && two != four && three != four) break;
    one = two;
    two = three;
    three = four;
    i++;
  }
  print('The sequence starts at ${i + 1}');
}