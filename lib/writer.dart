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

csvWriter(OverallResult result) {
  var privateTypedDeclarations =
      _countTypedDeclarations(result.privateCommented) +
      _countTypedDeclarations(result.privateUncommented);

  var privateUntypedDeclarations =
      _countTotalDeclarations(result.privateCommented) +
      _countTotalDeclarations(result.privateUncommented) -
      privateTypedDeclarations;

  var publicTypedDeclarations =
      _countTypedDeclarations(result.publicCommented) +
      _countTypedDeclarations(result.publicUncommented);

  var publicUntypedDeclarations =
      _countTotalDeclarations(result.publicCommented) +
      _countTotalDeclarations(result.publicUncommented) -
      publicTypedDeclarations;

  var commentedTypedDeclarations =
      _countTypedDeclarations(result.privateCommented) +
      _countTypedDeclarations(result.publicCommented);

  var commentedUntypedDeclarations =
      _countTotalDeclarations(result.privateCommented) +
      _countTotalDeclarations(result.publicCommented) -
      commentedTypedDeclarations;

  var uncommentedTypedDeclarations =
      _countTypedDeclarations(result.privateUncommented) +
      _countTypedDeclarations(result.publicUncommented);

  var uncommentedUntypedDeclarations =
      _countTotalDeclarations(result.privateUncommented) +
      _countTotalDeclarations(result.publicUncommented) -
      uncommentedTypedDeclarations;

  var totalDeclarations =
      _countTotalDeclarations(result.privateUncommented) +
      _countTotalDeclarations(result.privateCommented) +
      _countTotalDeclarations(result.publicUncommented) +
      _countTotalDeclarations(result.publicCommented);

  print(
      'privateTypedDeclarations,privateUntypedDeclarations,publicTypedDeclarations,publicUntypedDeclarations,'
      'commentedTypedDeclarations,commentedUntypedDeclarations,uncommentedTypedDeclarations,uncommentedUntypedDeclarations,'
      'typeCasts,totalDeclarations'
  );
  print(
      '$privateTypedDeclarations,$privateUntypedDeclarations,$publicTypedDeclarations,$publicUntypedDeclarations,'
      '$commentedTypedDeclarations,$commentedUntypedDeclarations,$uncommentedTypedDeclarations,$uncommentedUntypedDeclarations,'
      '${result.typeCasts},$totalDeclarations'
  );
}

_countTypedDeclarations(LibraryResult result) =>
  result.typedFunctionReturnTypeCount +
  result.typedFunctionArgumentCount +
  result.typedVariableCount +
  result.classes.values.fold(0, (count, result) => count + _countTypedClassDeclarations(result));

_countTotalDeclarations(LibraryResult result) =>
  result.functionCount +
  result.functionArgumentCount +
  result.variableCount +
  result.classes.values.fold(0, (count, result) => count + _countTotalClassDeclarations(result));

_countTypedClassDeclarations(ClassResult result) =>
  result.typedConstructorArgumentCount +
  result.typedMethodReturnTypeCount +
  result.typedMethodArgumentCount +
  result.typedVariableCount;

_countTotalClassDeclarations(ClassResult result) =>
  result.constructorArgumentCount +
  result.methodCount +
  result.methodArgumentCount +
  result.variableCount;

classCsvWriter(OverallResult result) {
  var apiSize = {};
  var allClasses = new Map.from(result.privateUncommented.classes);

  result.privateCommented.classes.forEach((name, result) {
    if (allClasses.containsKey(name)) {
      allClasses[name] += result;
    } else {
      allClasses[name] = result;
    }
  });

  result.publicUncommented.classes.forEach((name, result) {
    if (allClasses.containsKey(name)) {
      allClasses[name] += result;
    } else {
      allClasses[name] = result;
    }
    apiSize[name] = _countTotalClassDeclarations(result);
  });

  result.publicCommented.classes.forEach((name, result) {
    if (allClasses.containsKey(name)) {
      allClasses[name] += result;
    } else {
      allClasses[name] = result;
    }
    if (apiSize.containsKey(name)) {
      apiSize[name] += _countTotalClassDeclarations(result);
    } else {
      apiSize[name] = _countTotalClassDeclarations(result);
    }
  });

  print('name,totalDeclarations,publicDeclarations,typedDeclarations,untypedDeclarations');

  allClasses.forEach((name, result) {
    var totalDeclarations = _countTotalClassDeclarations(result);
    var publicDeclarations = apiSize.containsKey(name) ? apiSize[name] : 0;
    var typedDeclarations = _countTypedClassDeclarations(result);
    var untypedDeclarations = totalDeclarations - typedDeclarations;

    print('$name,$totalDeclarations,$publicDeclarations,$typedDeclarations,$untypedDeclarations');
  });
}
