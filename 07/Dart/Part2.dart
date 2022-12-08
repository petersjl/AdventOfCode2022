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
  int totalSpace = 70000000;
  int needed = 30000000;
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
  int available = totalSpace - curDir.size;
  Directory? smallest = findSmallest(curDir, needed, available);
  if(smallest == null) print('Cannot free enough space');
  else print('Smallest directory to free enough space is ${smallest.name} at size ${smallest.size}');
}

Directory? findSmallest(Directory d, int needed, int available){
  if(available + d.size < needed) return null;
  var currentSmallest = d;
  for(var dir in d.dirs){
    var check = findSmallest(dir, needed, available);
    if(check != null && check.size < currentSmallest.size) currentSmallest = check;
  }
  return currentSmallest;
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