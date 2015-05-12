// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

import 'package:typing_analyzer/analyzer.dart';
import 'package:typing_analyzer/finder.dart';
import 'package:typing_analyzer/parser.dart';
import 'package:typing_analyzer/writer.dart';

main(List<String> arguments) async {
  await for (var project in findProjects(arguments.first)) {
    print('Analyzing ${project.name}');
    var compilationUnits = parseDartFiles(project.path);
    var result = analyze(compilationUnits);

    csvWriter(result, project.name, project.url);
    classCsvWriter(result, project.name);
  }
}
