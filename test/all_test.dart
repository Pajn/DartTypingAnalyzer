// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

import 'dart:io' show Platform;

import 'package:guinness/guinness.dart';

import 'package:typing_analyzer/analyzer.dart';
import 'package:typing_analyzer/parser.dart';

main() {
  describe('Analyzer', () {
    it('should correctly pick up function declarations', () {
      var compilationUnits = parseDartFiles('${Platform.packageRoot}/typing_analyzer/parser.dart');
      var result = analyze(compilationUnits);

      expect(result.publicUncommented.functionCount).toEqual(0);
      expect(result.publicUncommented.typedFunctionReturnTypeCount).toEqual(0);
      expect(result.publicUncommented.argumentCount).toEqual(0);
      expect(result.publicUncommented.typedArgumentCount).toEqual(0);

      expect(result.publicCommented.functionCount).toEqual(1);
      expect(result.publicCommented.typedFunctionReturnTypeCount).toEqual(1);
      expect(result.publicCommented.argumentCount).toEqual(1);
      expect(result.publicCommented.typedArgumentCount).toEqual(1);

      expect(result.privateUncommented.functionCount).toEqual(0);
      expect(result.privateUncommented.typedFunctionReturnTypeCount).toEqual(0);
      expect(result.privateUncommented.argumentCount).toEqual(0);
      expect(result.privateUncommented.typedArgumentCount).toEqual(0);

      expect(result.privateCommented.functionCount).toEqual(2);
      expect(result.privateCommented.typedFunctionReturnTypeCount).toEqual(2);
      expect(result.privateCommented.argumentCount).toEqual(2);
      expect(result.privateCommented.typedArgumentCount).toEqual(2);

      expect(result.local.functionCount).toEqual(1);
      expect(result.local.argumentCount).toEqual(1);
      expect(result.local.typedArgumentCount).toEqual(0);
    });

    it('should correctly pick up variable declarations', () {
      var compilationUnits = parseDartFiles('${Platform.packageRoot}/typing_analyzer/analyzer.dart');
      var result = analyze(compilationUnits);

      expect(result.publicUncommented.variableCount).toEqual(19);
      expect(result.publicUncommented.typedVariableCount).toEqual(18);

      expect(result.publicCommented.variableCount).toEqual(0);
      expect(result.publicCommented.typedVariableCount).toEqual(0);

      expect(result.privateUncommented.variableCount).toEqual(0);
      expect(result.privateUncommented.typedVariableCount).toEqual(0);

      expect(result.privateCommented.variableCount).toEqual(0);
      expect(result.privateCommented.typedVariableCount).toEqual(0);

      expect(result.local.variableCount).toEqual(13);
      expect(result.local.typedVariableCount).toEqual(2);
    });
  });
}
