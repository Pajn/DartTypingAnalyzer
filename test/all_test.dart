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
      expect(result.publicUncommented.functionArgumentCount).toEqual(0);
      expect(result.publicUncommented.typedFunctionArgumentCount).toEqual(0);

      expect(result.publicCommented.functionCount).toEqual(1);
      expect(result.publicCommented.typedFunctionReturnTypeCount).toEqual(1);
      expect(result.publicCommented.functionArgumentCount).toEqual(1);
      expect(result.publicCommented.typedFunctionArgumentCount).toEqual(1);

      expect(result.privateUncommented.functionCount).toEqual(0);
      expect(result.privateUncommented.typedFunctionReturnTypeCount).toEqual(0);
      expect(result.privateUncommented.functionArgumentCount).toEqual(0);
      expect(result.privateUncommented.typedFunctionArgumentCount).toEqual(0);

      expect(result.privateCommented.functionCount).toEqual(2);
      expect(result.privateCommented.typedFunctionReturnTypeCount).toEqual(2);
      expect(result.privateCommented.functionArgumentCount).toEqual(2);
      expect(result.privateCommented.typedFunctionArgumentCount).toEqual(2);

      expect(result.local.functionCount).toEqual(1);
      expect(result.local.functionArgumentCount).toEqual(1);
      expect(result.local.typedFunctionArgumentCount).toEqual(0);
    });

    it('should correctly pick up variable declarations', () {
      var compilationUnits = parseDartFiles('${Platform.packageRoot}/typing_analyzer/analyzer.dart');
      var result = analyze(compilationUnits);

      expect(result.publicUncommented.variableCount).toEqual(21);
      expect(result.publicUncommented.typedVariableCount).toEqual(20);

      expect(result.publicCommented.variableCount).toEqual(0);
      expect(result.publicCommented.typedVariableCount).toEqual(0);

      expect(result.privateUncommented.variableCount).toEqual(0);
      expect(result.privateUncommented.typedVariableCount).toEqual(0);

      expect(result.privateCommented.variableCount).toEqual(0);
      expect(result.privateCommented.typedVariableCount).toEqual(0);

      expect(result.local.variableCount).toEqual(13);
      expect(result.local.typedVariableCount).toEqual(3);
    });

    it('should correctly pick up class declarations', () {
      var compilationUnits = parseDartFiles('${Platform.packageRoot}/typing_analyzer/analyzer.dart');
      var result = analyze(compilationUnits);

      expect(result.publicUncommented.classCount).toEqual(2);
      expect(result.publicUncommented.constructorCount).toEqual(0);
      expect(result.publicUncommented.constructorArgumentCount).toEqual(0);
      expect(result.publicUncommented.methodCount).toEqual(9);
      expect(result.publicUncommented.methodArgumentCount).toEqual(8);
      expect(result.publicUncommented.typedMethodReturnTypeCount).toEqual(3);
      expect(result.publicUncommented.typedMethodArgumentCount).toEqual(8);

      expect(result.publicCommented.classCount).toEqual(0);
      expect(result.publicCommented.constructorCount).toEqual(0);
      expect(result.publicCommented.constructorArgumentCount).toEqual(0);
      expect(result.publicCommented.methodCount).toEqual(1);
      expect(result.publicCommented.methodArgumentCount).toEqual(1);
      expect(result.publicCommented.typedMethodReturnTypeCount).toEqual(0);
      expect(result.publicCommented.typedMethodArgumentCount).toEqual(1);

      expect(result.privateUncommented.classCount).toEqual(1);
      expect(result.privateUncommented.constructorCount).toEqual(0);
      expect(result.privateUncommented.constructorArgumentCount).toEqual(0);
      expect(result.privateUncommented.methodCount).toEqual(0);
      expect(result.privateUncommented.methodArgumentCount).toEqual(0);
      expect(result.privateUncommented.typedMethodReturnTypeCount).toEqual(0);
      expect(result.privateUncommented.typedMethodArgumentCount).toEqual(0);

      expect(result.privateCommented.classCount).toEqual(0);
      expect(result.privateCommented.constructorCount).toEqual(0);
      expect(result.privateCommented.constructorArgumentCount).toEqual(0);
      expect(result.privateCommented.methodCount).toEqual(0);
      expect(result.privateCommented.methodArgumentCount).toEqual(0);
      expect(result.privateCommented.typedMethodReturnTypeCount).toEqual(0);
      expect(result.privateCommented.typedMethodArgumentCount).toEqual(0);
    });
  });
}
