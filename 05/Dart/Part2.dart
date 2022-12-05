import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().split('\r\n\r\n');
  List<String> crateStringMap = input[0].splitNewLine();
  List<List<int>> instructions = input[1].splitNewLine().listMap<List<int>>((line) {
    var parts = line.split(' ');
    return [parts[1], parts[3], parts[5]].listMap<int>((num) => int.parse(num));
  });
  String numRow = crateStringMap[crateStringMap.length-1];
  int numStacks = int.parse(numRow[numRow.length-2]);
  List<List<String>> crateStacks = List.generate(numStacks, (index) => [], growable: false);
  for(int i = crateStringMap.length - 2; i >= 0; --i){
    var line = crateStringMap[i];
    for(int j = 1; j < line.length; j += 4){
      var c = line[j];
      if(c != ' ') crateStacks[(j ~/ 4)].add(c);
    }
  }
  return [crateStacks, instructions];
}

// The main method of the puzzle solve
void solvePuzzle(){
  var input = parseInput() as List;
  var crateStacks = input[0] as List<List<String>>;
  var instructions = input[1] as List<List<int>>;
  for(var instruction in instructions){
    var tempstack = [];
    for(int i = 0; i < instruction[0]; ++i){
      tempstack.add(crateStacks[instruction[1]-1].removeLast());
    }
    while(tempstack.length > 0){
      crateStacks[instruction[2]-1].add(tempstack.removeLast());
    }
  }
  var tops = StringBuffer();
  for(var stack in crateStacks){
    tops.write(stack.removeLast());
  }
  print('The tops of each stack make $tops');
}