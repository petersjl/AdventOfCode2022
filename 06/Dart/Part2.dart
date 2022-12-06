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
  var chars = input.characters.listMap<int>((String char) => char.codeUnitAt(0));
  int index = 13;
  while(index < input.length){
    Set<int> s = {};
    for(int i = index - 13; i <= index; ++i){
      if(!s.add(chars[i])) break;
    }
    if(s.length == 14) break;
    index++;
  }
  if(index == chars.length) print('No start of message found');
  else print('The sequence starts at ${index + 1}');
}