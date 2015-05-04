// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

import 'package:typing_analyzer/analyzer.dart';

typedef Writer(OverallResult result);

debugWriter(OverallResult result) {
  print('Result: ');
  print('Local: ');

  print('variables: ${result.local.variableCount}');
  print('anon functions: ${result.local.functionCount}');
  print('anon functions args: ${result.local.functionArgumentCount}');
  print('typed anon functions param: ${result.local.typedFunctionArgumentCount}');

  print('Private: ');
  _debugResult(result.privateUncommented);

  print('Private Commented: ');
  _debugResult(result.privateCommented);

  print('Public: ');
  _debugResult(result.publicUncommented);

  print('Public Commented: ');
  _debugResult(result.publicCommented);

  print('type casts: ${result.typeCasts}');
}

_debugResult(LibraryResult result) {
  print('functions: ${result.functionCount}');
  print('func args: ${result.functionArgumentCount}');
  print('vars: ${result.variableCount}');

  print('typed func args: ${result.typedFunctionArgumentCount} (${_p(result.typedFunctionArgumentCount/result.functionArgumentCount)}%)');
  print('typed func return: ${result.typedFunctionReturnTypeCount} (${_p(result.typedFunctionReturnTypeCount/result.functionCount)}%)');
  print('typed vars: ${result.typedVariableCount} (${_p(result.typedVariableCount/result.variableCount)}%)');

  print('classes: ${result.classCount}');
  result.classes.forEach((name, value) {
    print(name);

    _debugClass(value);
  });
}

_debugClass(ClassResult result) {
  print('constructors: ${result.constructorCount}');
  print('constructor arguments: ${result.constructorArgumentCount}');
  print('methods: ${result.methodCount}');
  print('method args: ${result.methodArgumentCount}');

  print('typed constructor arguments: ${result.typedConstructorArgumentCount} (${_p(result.typedConstructorArgumentCount/result.constructorArgumentCount)}%)');
  print('typed meth args: ${result.typedMethodArgumentCount} (${_p(result.typedMethodArgumentCount/result.methodArgumentCount)}%)');
  print('typed meth return: ${result.typedMethodReturnTypeCount} (${_p(result.typedMethodReturnTypeCount/result.methodCount)}%)');
}

_p(num percent) => percent.isNaN ? '-' : (percent * 100).round();
