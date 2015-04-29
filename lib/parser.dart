// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

/// A wrapper around the analyzer package so that a directory can be specified
library parser;

import 'dart:io';
import 'package:analyzer/analyzer.dart';
import 'package:path/path.dart' as pathTools;

export 'package:analyzer/analyzer.dart';

/// Parses all Dart files in [path] into ASTs.
List<CompilationUnit> parseDartFiles(String path) {
  var files = _findDartFiles(path);
  return _parseDartFiles(files);
}

/// Finds all Dart files in [path] recursively
List<String> _findDartFiles(String path) {
  var uri = new Uri.file(pathTools.absolute(path));
  var files = [];

  try {
    new Directory.fromUri(uri).listSync().forEach((entity) {
      var type = FileSystemEntity.typeSync(entity.path);

      if (type == FileSystemEntityType.DIRECTORY) {
        if (pathTools.basename(entity.path) != 'packages') {
          files.addAll(_findDartFiles(entity.path));
        }
      } else if (type != FileSystemEntityType.FILE) {
        return;
      }

      if (pathTools.extension(entity.path) != '.dart') {
        return;
      }

      files.add(entity.absolute.path);
    });
  } on FileSystemException catch(e) {
    if (e.message == 'Directory listing failed') {
      return [path];
    }
    throw e;
  }

  return files;
}

/// Parses all Dart files into ASTs.
List<CompilationUnit> _parseDartFiles(List<String> paths) =>
  paths.map(parseDartFile).toList();
