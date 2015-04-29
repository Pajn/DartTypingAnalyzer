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
  print('anon functions args: ${result.local.argumentCount}');
  print('typed anon functions param: ${result.local.typedArgumentCount}');

  print('Private: ');
  print('classes: ${result.privateUncommented.classCount}');
  print('constructors: ${result.privateUncommented.constructorCount}');
  print('constructor arguments: ${result.privateUncommented.constructorArgumentCount}');
  print('methods: ${result.privateUncommented.methodCount}');
  print('functions: ${result.privateUncommented.functionCount}');
  print('args: ${result.privateUncommented.argumentCount}');
  print('vars: ${result.privateUncommented.variableCount}');

  print('typed constructor arguments: ${result.privateUncommented.typedConstructorArgumentCount}');
  print('typed args: ${result.privateUncommented.typedArgumentCount}');
  print('typed meth return: ${result.privateUncommented.typedMethodReturnTypeCount}');
  print('typed func return: ${result.privateUncommented.typedFunctionReturnTypeCount}');
  print('typed vars: ${result.privateUncommented.typedVariableCount}');

  print('Private Commented: ');
  print('classes: ${result.privateCommented.classCount}');
  print('constructors: ${result.privateCommented.constructorCount}');
  print('constructor arguments: ${result.privateCommented.constructorArgumentCount}');
  print('methods: ${result.privateCommented.methodCount}');
  print('functions: ${result.privateCommented.functionCount}');
  print('args: ${result.privateCommented.argumentCount}');
  print('vars: ${result.privateCommented.variableCount}');

  print('typed constructor arguments: ${result.privateCommented.typedConstructorArgumentCount}');
  print('typed args: ${result.privateCommented.typedArgumentCount}');
  print('typed meth return: ${result.privateCommented.typedMethodReturnTypeCount}');
  print('typed func return: ${result.privateCommented.typedFunctionReturnTypeCount}');
  print('typed vars: ${result.privateCommented.typedVariableCount}');

  print('Public: ');
  print('classes: ${result.publicUncommented.classCount}');
  print('constructors: ${result.publicUncommented.constructorCount}');
  print('constructor arguments: ${result.publicUncommented.constructorArgumentCount}');
  print('methods: ${result.publicUncommented.methodCount}');
  print('functions: ${result.publicUncommented.functionCount}');
  print('args: ${result.publicUncommented.argumentCount}');
  print('vars: ${result.publicUncommented.variableCount}');

  print('typed constructor arguments: ${result.publicUncommented.typedConstructorArgumentCount}');
  print('typed args: ${result.publicUncommented.typedArgumentCount}');
  print('typed meth return: ${result.publicUncommented.typedMethodReturnTypeCount}');
  print('typed func return: ${result.publicUncommented.typedFunctionReturnTypeCount}');
  print('typed vars: ${result.publicUncommented.typedVariableCount}');

  print('Public Commented: ');
  print('classes: ${result.publicCommented.classCount}');
  print('constructors: ${result.publicCommented.constructorCount}');
  print('constructor arguments: ${result.publicCommented.constructorArgumentCount}');
  print('methods: ${result.publicCommented.methodCount}');
  print('functions: ${result.publicCommented.functionCount}');
  print('args: ${result.publicCommented.argumentCount}');
  print('vars: ${result.publicCommented.variableCount}');

  print('typed constructor arguments: ${result.publicCommented.typedConstructorArgumentCount}');
  print('typed args: ${result.publicCommented.typedArgumentCount}');
  print('typed meth return: ${result.publicCommented.typedMethodReturnTypeCount}');
  print('typed func return: ${result.publicCommented.typedFunctionReturnTypeCount}');
  print('typed vars: ${result.publicCommented.typedVariableCount}');

  print('type casts: ${result.typeCasts}');
}
