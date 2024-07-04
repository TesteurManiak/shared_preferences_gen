import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';
import 'package:source_gen/source_gen.dart';

// const _supportedSharedPrefTypes = <String, Type>{
//   'bool': bool,
//   'double': double,
//   'int': int,
//   'String': String,
//   'List<String>': List<String>,
// };

const _annotations = <Type>{
  SharedPrefData,
};

class SharedPreferencesGenerator extends Generator {
  const SharedPreferencesGenerator();

  TypeChecker get _typeChecker =>
      TypeChecker.any(_annotations.map((e) => TypeChecker.fromRuntime(e)));

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final getters = <String>{};

    generateForAnnotation(library, getters);

    if (getters.isEmpty) return '';

    // TODO: implement generate

    return '''
extension SharedPreferencesGenX on SharedPreferences {
}
    ''';
  }

  void generateForAnnotation(LibraryReader library, Set<String> getters) {
    for (final annotatedElement in library.annotatedWith(_typeChecker)) {
      final generatedValue = _generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
      );

      // TODO: implement generateForAnnotation
      getters.add(generatedValue);
    }
  }

  String _generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
  ) {
    final typedAnnotation =
        annotation.objectValue.type!.getDisplayString(withNullability: false);
    // final type = typedAnnotation.substring(0, typedAnnotation.indexOf('<'));

    // TODO: implement _generateForAnnotatedElement
    return typedAnnotation;
  }
}
