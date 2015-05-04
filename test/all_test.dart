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

      expect(result.publicUncommented.variableCount).toEqual(0);
      expect(result.publicUncommented.typedVariableCount).toEqual(0);

      expect(result.publicCommented.variableCount).toEqual(0);
      expect(result.publicCommented.typedVariableCount).toEqual(0);

      expect(result.privateUncommented.variableCount).toEqual(0);
      expect(result.privateUncommented.typedVariableCount).toEqual(0);

      expect(result.privateCommented.variableCount).toEqual(0);
      expect(result.privateCommented.typedVariableCount).toEqual(0);

      expect(result.local.variableCount).toEqual(15);
      expect(result.local.typedVariableCount).toEqual(2);
    });

    it('should correctly pick up class declarations', () {
      var compilationUnits = parseDartFiles('${Platform.packageRoot}/typing_analyzer/analyzer.dart');
      var result = analyze(compilationUnits);

      expect(result.publicUncommented.classCount).toEqual(3);
      expect(result.publicUncommented.classes.length).toEqual(4);
      expect(result.publicUncommented.classes['ClassResult'].variableCount).toEqual(9);
      expect(result.publicUncommented.classes['ClassResult'].constructorCount).toEqual(0);
      expect(result.publicUncommented.classes['ClassResult'].constructorArgumentCount).toEqual(0);
      expect(result.publicUncommented.classes['ClassResult'].methodCount).toEqual(1);
      expect(result.publicUncommented.classes['ClassResult'].methodArgumentCount).toEqual(1);
      expect(result.publicUncommented.classes['ClassResult'].typedVariableCount).toEqual(9);
      expect(result.publicUncommented.classes['ClassResult'].typedMethodReturnTypeCount).toEqual(1);
      expect(result.publicUncommented.classes['ClassResult'].typedMethodArgumentCount).toEqual(1);

      expect(result.publicUncommented.classes['LibraryResult'].variableCount).toEqual(8);
      expect(result.publicUncommented.classes['LibraryResult'].constructorCount).toEqual(0);
      expect(result.publicUncommented.classes['LibraryResult'].constructorArgumentCount).toEqual(0);
      expect(result.publicUncommented.classes['LibraryResult'].methodCount).toEqual(1);
      expect(result.publicUncommented.classes['LibraryResult'].methodArgumentCount).toEqual(1);
      expect(result.publicUncommented.classes['LibraryResult'].typedVariableCount).toEqual(8);
      expect(result.publicUncommented.classes['LibraryResult'].typedMethodReturnTypeCount).toEqual(1);
      expect(result.publicUncommented.classes['LibraryResult'].typedMethodArgumentCount).toEqual(1);

      expect(result.publicUncommented.classes['OverallResult'].variableCount).toEqual(6);
      expect(result.publicUncommented.classes['OverallResult'].constructorCount).toEqual(0);
      expect(result.publicUncommented.classes['OverallResult'].constructorArgumentCount).toEqual(0);
      expect(result.publicUncommented.classes['OverallResult'].methodCount).toEqual(4);
      expect(result.publicUncommented.classes['OverallResult'].methodArgumentCount).toEqual(1);
      expect(result.publicUncommented.classes['OverallResult'].typedVariableCount).toEqual(6);
      expect(result.publicUncommented.classes['OverallResult'].typedMethodReturnTypeCount).toEqual(4);
      expect(result.publicUncommented.classes['OverallResult'].typedMethodArgumentCount).toEqual(1);

      expect(result.publicUncommented.classes['_Analyzer'].variableCount).toEqual(1);
      expect(result.publicUncommented.classes['_Analyzer'].constructorCount).toEqual(1);
      expect(result.publicUncommented.classes['_Analyzer'].constructorArgumentCount).toEqual(0);
      expect(result.publicUncommented.classes['_Analyzer'].methodCount).toEqual(6);
      expect(result.publicUncommented.classes['_Analyzer'].methodArgumentCount).toEqual(6);
      expect(result.publicUncommented.classes['_Analyzer'].typedVariableCount).toEqual(0);
      expect(result.publicUncommented.classes['_Analyzer'].typedMethodReturnTypeCount).toEqual(0);
      expect(result.publicUncommented.classes['_Analyzer'].typedMethodArgumentCount).toEqual(6);

      expect(result.publicCommented.classCount).toEqual(0);
      expect(result.publicCommented.classes.length).toEqual(1);

      expect(result.publicCommented.classes['_Analyzer'].variableCount).toEqual(0);
      expect(result.publicCommented.classes['_Analyzer'].constructorCount).toEqual(0);
      expect(result.publicCommented.classes['_Analyzer'].constructorArgumentCount).toEqual(0);
      expect(result.publicCommented.classes['_Analyzer'].methodCount).toEqual(1);
      expect(result.publicCommented.classes['_Analyzer'].methodArgumentCount).toEqual(1);
      expect(result.publicCommented.classes['_Analyzer'].typedVariableCount).toEqual(0);
      expect(result.publicCommented.classes['_Analyzer'].typedMethodReturnTypeCount).toEqual(0);
      expect(result.publicCommented.classes['_Analyzer'].typedMethodArgumentCount).toEqual(1);

      expect(result.privateUncommented.classCount).toEqual(1);
      expect(result.privateUncommented.classes.length).toEqual(0);

      expect(result.privateCommented.classCount).toEqual(0);
      expect(result.privateCommented.classes.length).toEqual(0);
    });
  });
}
