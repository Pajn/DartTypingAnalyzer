// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

/// Analyses a collection of ASTs to produce statistics about the usages of Types
library analyzer;

import 'package:analyzer/analyzer.dart';

class Result {
  int variableCount = 0;
  int constructorArgumentCount = 0;
  int constructorCount = 0;
  int argumentCount = 0;
  int functionCount = 0;
  int methodCount = 0;
  int classCount = 0;

  int typedVariableCount = 0;
  int typedConstructorArgumentCount = 0;
  int typedArgumentCount = 0;
  int typedFunctionReturnTypeCount = 0;
  int typedMethodReturnTypeCount = 0;

  Result operator +(Result other) =>
    new Result()
      ..variableCount = variableCount + other.variableCount
      ..constructorArgumentCount = constructorArgumentCount + other.constructorArgumentCount
      ..constructorCount = constructorCount + other.constructorCount
      ..argumentCount = argumentCount + other.argumentCount
      ..functionCount = functionCount + other.functionCount
      ..methodCount = methodCount + other.methodCount
      ..classCount = classCount + other.classCount

      ..typedVariableCount = typedVariableCount + other.typedVariableCount
      ..typedConstructorArgumentCount = typedConstructorArgumentCount + other.typedConstructorArgumentCount
      ..typedArgumentCount = typedArgumentCount + other.typedArgumentCount
      ..typedFunctionReturnTypeCount = typedFunctionReturnTypeCount + other.typedFunctionReturnTypeCount
      ..typedMethodReturnTypeCount = typedMethodReturnTypeCount + other.typedMethodReturnTypeCount;
}

class OverallResult {
  Result local = new Result();
  Result privateUncommented = new Result();
  Result privateCommented = new Result();
  Result publicUncommented = new Result();
  Result publicCommented = new Result();
  int typeCasts = 0;

  Result get overall => privateUncommented + publicUncommented;

  OverallResult operator +(OverallResult other) =>
    new OverallResult()
      ..local = local + other.local
      ..privateUncommented = privateUncommented + other.privateUncommented
      ..privateCommented = privateCommented + other.privateCommented
      ..publicUncommented = publicUncommented + other.publicUncommented
      ..publicCommented = publicCommented + other.publicCommented
      ..typeCasts = typeCasts + other.typeCasts;
}

OverallResult analyze(Iterable<CompilationUnit> compilationUnits) =>
  compilationUnits.fold(
      new OverallResult(),
      (result, compilationUnit) => result + _analyze(compilationUnit)
  );

OverallResult _analyze(CompilationUnit compilationUnit) {
  var analyzer = new _Analyzer();
  compilationUnit.visitChildren(analyzer);
  return analyzer.result;
}

class _Analyzer extends RecursiveAstVisitor {
  final result = new OverallResult();

  @override
  visitAsExpression(AsExpression node) {
    this.result.typeCasts++;

    super.visitAsExpression(node);
  }

  @override
  visitClassDeclaration(ClassDeclaration node) {
    var result;
    if (Identifier.isPrivateName(node.name.name)) {
      if (node.documentationComment == null) {
        result = this.result.privateUncommented;
      } else {
        result = this.result.privateCommented;
      }
    } else {
      if (node.documentationComment == null) {
        result = this.result.publicUncommented;
      } else {
        result = this.result.publicCommented;
      }
    }

    result.classCount++;

    super.visitClassDeclaration(node);
  }

  @override
  visitConstructorDeclaration(ConstructorDeclaration node) {
    var result;
    if (Identifier.isPrivateName(node.name.name)) {
      if (node.documentationComment == null) {
        result = this.result.privateUncommented;
      } else {
        result = this.result.privateCommented;
      }
    } else {
      if (node.documentationComment == null) {
        result = this.result.publicUncommented;
      } else {
        result = this.result.publicCommented;
      }
    }

    result.constructorCount++;

    var arguments = node.parameters.childEntities.where((e) => e is FormalParameter);
    var typedArguments = arguments.where((a) => a.childEntities.any((e) =>
        e is TypeName && e.name.name != 'dynamic'));

    result.constructorArgumentCount += arguments.length;
    result.typedConstructorArgumentCount += typedArguments.length;

    super.visitConstructorDeclaration(node);
  }

  @override
  visitFunctionDeclaration(FunctionDeclaration node) {
    var result;
    if (Identifier.isPrivateName(node.name.name)) {
      if (node.documentationComment == null) {
        result = this.result.privateUncommented;
      } else {
        result = this.result.privateCommented;
      }
    } else {
      if (node.documentationComment == null) {
        result = this.result.publicUncommented;
      } else {
        result = this.result.publicCommented;
      }
    }

    result.functionCount++;

    if (node.returnType != null && node.returnType.name.name != 'dynamic') {
      result.typedFunctionReturnTypeCount++;
    }
    super.visitFunctionDeclaration(node);
  }

  /// [FunctionExpression] is the parameter list and body of all functions, however for
  /// anonymous functions the expression does not have a [FunctionDeclaration] as a parent
  @override
  visitFunctionExpression(FunctionExpression node) {
    var arguments = node.parameters.childEntities.where((e) => e is FormalParameter);
    var typedArguments = arguments.where((a) => a.childEntities.any((e) =>
        e is TypeName && e.name.name != 'dynamic'));

    if (node.parent is FunctionDeclaration) {
      var result;
      if (Identifier.isPrivateName(node.parent.name.name)) {
        if (node.parent.documentationComment == null) {
          result = this.result.privateUncommented;
        } else {
          result = this.result.privateCommented;
        }
      } else {
        if (node.parent.documentationComment == null) {
          result = this.result.publicUncommented;
        } else {
          result = this.result.publicCommented;
        }
      }

      result.argumentCount += arguments.length;
      result.typedArgumentCount += typedArguments.length;
    } else {
      result.local.functionCount++;

      result.local.argumentCount += arguments.length;
      result.local.typedArgumentCount += typedArguments.length;
    }
    super.visitFunctionExpression(node);
  }

  @override
  visitMethodDeclaration(MethodDeclaration node) {
    var result;
    if (Identifier.isPrivateName(node.name.name)) {
      if (node.documentationComment == null) {
        result = this.result.privateUncommented;
      } else {
        result = this.result.privateCommented;
      }
    } else {
      if (node.documentationComment == null) {
        result = this.result.publicUncommented;
      } else {
        result = this.result.publicCommented;
      }
    }

    result.methodCount++;

    if (node.parameters != null) {
      Iterable arguments = node.parameters.childEntities.where((e) => e is FormalParameter);
      var typedArguments = arguments.where((a) => a.childEntities.any((e) =>
      e is TypeName && e.name.name != 'dynamic'));

      result.argumentCount += arguments.length;
      result.typedArgumentCount += typedArguments.length;
    }

    if (node.returnType != null && node.returnType.name.name != 'dynamic') {
      result.typedMethodReturnTypeCount++;
    }
    super.visitMethodDeclaration(node);
  }

  @override
  visitVariableDeclaration(VariableDeclaration node) {
    Result result;
    print(node.parent.parent.runtimeType);
    if (node.parent.parent is TopLevelVariableDeclaration ||
        node.parent.parent is FieldDeclaration) {
      if (Identifier.isPrivateName(node.name.name)) {
        if (node.documentationComment == null) {
          result = this.result.privateUncommented;
        } else {
          result = this.result.privateCommented;
        }
      } else {
        if (node.documentationComment == null) {
          result = this.result.publicUncommented;
        } else {
          result = this.result.publicCommented;
        }
      }
    } else {
      result = this.result.local;
    }
    result.variableCount++;

    if (node.parent.childEntities.any((e) => e is TypeName && e.name.name != 'dynamic')) {
      result.typedVariableCount++;
    }

    super.visitVariableDeclaration(node);
  }
}
