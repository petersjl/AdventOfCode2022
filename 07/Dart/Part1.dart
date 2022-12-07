import 'dart:io';
import '../../DartUtils.dart';

void main(){
  Stopwatch stopwatch = new Stopwatch()..start();
  solvePuzzle();
  print('Ran in ${stopwatch.elapsedMilliseconds * 1/1000} seconds');
}

Object parseInput([bool test = false]){
  String filePath = Utils.to_abs_path(test ? '../testinput.txt' : '../input.txt');
  var input = File(filePath).readAsStringSync().splitNewLine();
  return input;
}

// The main method of the puzzle solve
void solvePuzzle(){
  var log = parseInput() as List<String>;
  int max = 100000;
  var curDir = Directory('/');
  for(var line in log){
    var parts = line.split(' ');
    switch(parts[0]){
      case '\$':
        if(parts[1] == 'ls') continue;
        switch(parts[2]){
          case '/': curDir = curDir.root(); break;
          case '..': curDir = curDir.back(); break;
          default: curDir = curDir.cd(parts[2]); break;
        }
        break;
      case 'dir': curDir.addDir(parts[1]); break;
      default: curDir.addFile(parts[1], int.parse(parts[0])); break;
    }
  }
  curDir = curDir.root();
  int totalCount = sumSmalls(curDir, max);
  print('Sum of dirs smaller than $max is $totalCount');
}

int sumSmalls(Directory d, int max){
  int total = 0;
  for(var dir in d.dirs) total += sumSmalls(dir, max);
  if(d.size <= max) total += d.size;
  return total;
}

class Directory{
  String name;
  List<Directory> dirs;
  List<Pair<String,int>> files;
  int _size;
  int get size => _size;

  Directory? parent;

  Directory(this.name,[this.parent = null]):dirs = [], files = [], _size = 0;

  Directory cd(String path){
    Directory? dest = dirs.whereFirst<Directory>((Directory element) => element.name == path);
    if(dest != null) return dest;
    throw RangeError('Invalid path name $path in directory $name');
  }

  Directory back() {
    if(parent != null) return parent!;
    throw StateError('Called back on root');
  }

  Directory root(){
    Directory cur = this;
    while(cur.parent != null) cur = cur.parent!;
    return cur;
  }

  void addDir(String name){
    dirs.add(Directory(name, this));
  }

  void addFile(String name, int fileSize){
    files.add(Pair(name, fileSize));
    increaseSize(fileSize);
  }

  void increaseSize(int amount){
    _size += amount;
    parent?.increaseSize(amount);
  }

  void printTree([String prefix = '']){
    print('$prefix- (dir) $name ($size)');
    var newPre = prefix + '\t';
    for(var file in files) print('$newPre- ${file.first} (${file.second})');
    for(var dir in dirs) dir.printTree(newPre); 
  }
}