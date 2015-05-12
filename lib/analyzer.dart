// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

/// Analyses a collection of ASTs to produce statistics about the usages of Types
library analyzer;

import 'package:analyzer/analyzer.dart';

class ClassResult {
  final bool abstract;

  int variableCount = 0;
  int constructorArgumentCount = 0;
  int constructorCount = 0;
  int methodArgumentCount = 0;
  int methodCount = 0;

  int typedVariableCount = 0;
  int typedConstructorArgumentCount = 0;
  int typedMethodArgumentCount = 0;
  int typedMethodReturnTypeCount = 0;

  ClassResult(this.abstract);

  ClassResult operator +(ClassResult other) =>
    new ClassResult(abstract)
      ..variableCount = variableCount + other.variableCount
      ..constructorArgumentCount = constructorArgumentCount + other.constructorArgumentCount
      ..constructorCount = constructorCount + other.constructorCount
      ..methodArgumentCount = methodArgumentCount + other.methodArgumentCount
      ..methodCount = methodCount + other.methodCount

      ..typedVariableCount = typedVariableCount + other.typedVariableCount
      ..typedConstructorArgumentCount = typedConstructorArgumentCount + other.typedConstructorArgumentCount
      ..typedMethodArgumentCount = typedMethodArgumentCount + other.typedMethodArgumentCount
      ..typedMethodReturnTypeCount = typedMethodReturnTypeCount + other.typedMethodReturnTypeCount;
}

class LibraryResult {
  int variableCount = 0;
  int functionArgumentCount = 0;
  int functionCount = 0;
  int classCount = 0;

  int typedVariableCount = 0;
  int typedFunctionArgumentCount = 0;
  int typedFunctionReturnTypeCount = 0;

  Map<String, ClassResult> classes = {};

  LibraryResult operator +(LibraryResult other) =>
    new LibraryResult()
      ..variableCount = variableCount + other.variableCount
      ..functionArgumentCount = functionArgumentCount + other.functionArgumentCount
      ..functionCount = functionCount + other.functionCount

      ..typedVariableCount = typedVariableCount + other.typedVariableCount
      ..typedFunctionArgumentCount = typedFunctionArgumentCount + other.typedFunctionArgumentCount
      ..typedFunctionReturnTypeCount = typedFunctionReturnTypeCount + other.typedFunctionReturnTypeCount
      ..classCount = classCount + other.classCount

      ..classes = (new Map.from(classes)..addAll(other.classes));
}

class OverallResult {
  LibraryResult local = new LibraryResult();
  LibraryResult privateUncommented = new LibraryResult();
  LibraryResult privateCommented = new LibraryResult();
  LibraryResult publicUncommented = new LibraryResult();
  LibraryResult publicCommented = new LibraryResult();
  int typeCasts = 0;

  LibraryResult get commented => privateCommented + publicCommented;
  LibraryResult get uncommented => privateUncommented + publicUncommented;
  LibraryResult get overall => commented + uncommented;

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

  _Analyzer();

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

    this.result.privateUncommented.classes[node.name.name] = new ClassResult(node.abstractKeyword != null);
    this.result.privateCommented.classes[node.name.name] = new ClassResult(node.abstractKeyword != null);
    this.result.publicUncommented.classes[node.name.name] = new ClassResult(node.abstractKeyword != null);
    this.result.publicCommented.classes[node.name.name] = new ClassResult(node.abstractKeyword != null);

    super.visitClassDeclaration(node);
  }

  @override
  visitConstructorDeclaration(ConstructorDeclaration node) {
    var libraryResult;
    // node.name is null on default (unnamed) constructors
    if (node.name != null && Identifier.isPrivateName(node.name.name)) {
      if (node.documentationComment == null) {
        libraryResult = this.result.privateUncommented;
      } else {
        libraryResult = this.result.privateCommented;
      }
    } else {
      if (node.documentationComment == null) {
        libraryResult = this.result.publicUncommented;
      } else {
        libraryResult = this.result.publicCommented;
      }
    }

    var result = libraryResult.classes[node.parent.name.name];

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
    var arguments = const [];
    if (node.parameters != null) {
      arguments = node.parameters.childEntities.where((e) => e is FormalParameter);
    }
    var typedArguments = arguments.where((a) => a.childEntities.any((e) =>
        e is TypeName && e.name.name != 'dynamic'));

    if (node.parent is FunctionDeclaration) {
      LibraryResult result;
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

      result.functionArgumentCount += arguments.length;
      result.typedFunctionArgumentCount += typedArguments.length;
    } else {
      result.local.functionCount++;

      result.local.functionArgumentCount += arguments.length;
      result.local.typedFunctionArgumentCount += typedArguments.length;
    }
    super.visitFunctionExpression(node);
  }

  @override
  visitMethodDeclaration(MethodDeclaration node) {
    var libraryResult;
    // node.name is null on default (unnamed) constructors
    if (node.name != null && Identifier.isPrivateName(node.name.name)) {
      if (node.documentationComment == null) {
        libraryResult = this.result.privateUncommented;
      } else {
        libraryResult = this.result.privateCommented;
      }
    } else {
      if (node.documentationComment == null) {
        libraryResult = this.result.publicUncommented;
      } else {
        libraryResult = this.result.publicCommented;
      }
    }

    var result = libraryResult.classes[node.parent.name.name];

    result.methodCount++;

    if (node.parameters != null) {
      Iterable arguments = node.parameters.childEntities.where((e) => e is FormalParameter);
      var typedArguments = arguments.where((a) => a.childEntities.any((e) =>
      e is TypeName && e.name.name != 'dynamic'));

      result.methodArgumentCount += arguments.length;
      result.typedMethodArgumentCount += typedArguments.length;
    }

    if (node.returnType != null && node.returnType.name.name != 'dynamic') {
      result.typedMethodReturnTypeCount++;
    }
    super.visitMethodDeclaration(node);
  }

  @override
  visitVariableDeclaration(VariableDeclaration node) {
    var result;
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

    if (node.parent.parent.parent is ClassDeclaration) {
      result = result.classes[node.parent.parent.parent.name.name];
    }

    result.variableCount++;

    if (node.parent.childEntities.any((e) => e is TypeName && e.name.name != 'dynamic')) {
      result.typedVariableCount++;
    }

    super.visitVariableDeclaration(node);
  }
}
