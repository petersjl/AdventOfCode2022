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
  Map<int, Monkey> map = {};
  for(var line in input){
    Monkey m = Monkey(line);
    map[m.id] = m;
  }
  return map;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var monkeys = parseInput() as Map<int,Monkey>;
  int numRounds = 20;
  int round = 0;
  while(round < numRounds){
    for(int i = 0; i < monkeys.length; ++i){
      var currentMonkey = monkeys[i]!;
      var itemPair = currentMonkey.takeTurn();
      while(itemPair != null){
        monkeys[itemPair.first]!.items.add(itemPair.second);
        itemPair = currentMonkey.takeTurn();
      }
    }
    round++;
  }
  var queue = PriorityQueue<Monkey>((queueItem, toInsert) => toInsert.inspectionCount - queueItem.inspectionCount);
  for(var monkey in monkeys.values) queue.enqueue(monkey);

  int monkeyBusiness = queue.dequeue().inspectionCount * queue.dequeue().inspectionCount;

  print('After $numRounds rounds, monkey business is $monkeyBusiness');
}

class Monkey{
  late int id;
  List<int> items;
  late int Function(int,int) op;
  int? arg2;
  late int check;
  late int trueTarget;
  late int falseTarget;
  int _icount;
  int get inspectionCount => _icount;

  Monkey(String str):items = [],_icount = 0{
    var lines = str.splitNewLine();
    id = int.parse(lines[0].split(new RegExp(' |:'))[1]);
    items = lines[1].split(': ')[1].split(', ').listMap<int>((String piece) => int.parse(piece));
    var opParts = lines[2].split('= ')[1].split(' ');
    op = opParts[1] == '+' ? _add : _mul;
    arg2 = opParts[2] == 'old' ? null : int.parse(opParts[2]);
    var whiteSpace = new RegExp(' +');
    check = int.parse(lines[3].split(whiteSpace)[4]);
    trueTarget = int.parse(lines[4].split(whiteSpace)[6]);
    falseTarget = int.parse(lines[5].split(whiteSpace)[6]);
  }

  Pair<int,int>? takeTurn(){
    if(items.isEmpty) return null;
    _icount++;
    var item = items.removeAt(0);
    item = op(item, arg2 ?? item) ~/ 3;
    return Pair(item % check == 0 ? trueTarget : falseTarget, item);
  }

  int _add(int a, int b) => a + b;
  int _mul(int a, int b) => a * b;
}