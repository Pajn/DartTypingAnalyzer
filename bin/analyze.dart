// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

import 'package:typing_analyzer/analyzer.dart';
import 'package:typing_analyzer/parser.dart';
import 'package:typing_analyzer/writer.dart';

main(List<String> arguments) {
  if (arguments.length != 1) {
    print ('Usage:\n    analyze path');
  }

  var compilationUnits = parseDartFiles(arguments.first);
  var result = analyze(compilationUnits);
//  debugWriter(result);
  csvWriter(result);
  classCsvWriter(result);
}
