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
  List<List> arrays = [];
  for(var pair in input){
    var lines = pair.splitNewLine();
    arrays.add(parseArray(lines[0]));
    arrays.add(parseArray(lines[1]));
  }
  return arrays;
}

List parseArray(String line){
  var stripped = splitPieces(line.substring(1,line.length - 1));
  List pieces = [];
  for(var item in stripped){
    if(item.isEmpty) break;
    else if(item[0] == '[') pieces.add(parseArray(item));
    else pieces.add(int.parse(item));
  }
  return pieces;
}

List<String> splitPieces(String line){
  List<String> parts = [];
  int start = 0;
  int openBrackets = 0;
  for(int i = 0; i < line.length; ++i){
    if(line[i] == '[') openBrackets++;
    else if(line[i] == ']') openBrackets--;
    else if(line[i] == ',' && openBrackets == 0){
      parts.add(line.substring(start, i));
      start = i + 1;
    }
  }
  if(start != line.length) parts.add(line.substring(start, line.length));
  return parts;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var arrays = parseInput() as List<List>;
  var dividerOne = [[2]];
  var dividerTwo = [[6]];
  arrays.add(dividerOne);
  arrays.add(dividerTwo);
  arrays.sort(((a, b) => compareLists(b, a)));
  int count = 1;
  for(int i = 0; i < arrays.length; ++i){
    var pair = arrays[i];
    if(pair == dividerOne || pair == dividerTwo) count *= i+1;
  }
  print('Decoder key is $count');
}

int compareLists(List left, List right){
  for(int i = 0; i < left.length; ++i){
    if(i == right.length) return -1;
    if(left[i] is int && right[i] is int){
      var compare = (left[i] as int).compareTo((right[i] as int));
      if(compare != 0) return compare.sign * -1;
    }
    else if(left[i] is List && right[i] is List){
      var compare = compareLists(left[i], right[i]);
      if(compare != 0) return compare;
    }
    else if(left[i] is List){
      var compare = compareLists(left[i], [right[i]]);
      if(compare != 0) return compare;
    }
    else{
      var compare = compareLists([left[i]], right[i]);
      if(compare != 0) return compare;
    }
  }
  return left.length < right.length ? 1 : 0;
}