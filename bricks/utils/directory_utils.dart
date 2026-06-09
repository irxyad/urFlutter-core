import 'dart:io';

/// Mencari project root dengan naik folder sampai ketemu pubspec.yaml
Directory findProjectRoot() {
  var projectRoot = Directory.current;

  while (!File('${projectRoot.path}/pubspec.yaml').existsSync()) {
    final parent = projectRoot.parent;

    if (parent.path == projectRoot.path) {
      throw Exception(
        'pubspec.yaml not found. Make sure you run this from inside a Flutter project.',
      );
    }

    projectRoot = parent;
  }

  return projectRoot;
}
