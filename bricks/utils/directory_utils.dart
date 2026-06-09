import 'dart:io';

/// Mencari project root dengan naik folder sampai ketemu pubspec.yaml
Directory findProjectRoot() {
  var dir = Directory.current;
  while (!File('${dir.path}/pubspec.yaml').existsSync()) {
    dir = dir.parent;
  }
  return dir;
}
