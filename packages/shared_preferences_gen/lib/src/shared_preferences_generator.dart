import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';
import 'package:source_gen/source_gen.dart';

const _annotations = <Type>{
  SharedPrefData,
};

class SharedPreferencesGenerator extends Generator {
  const SharedPreferencesGenerator();

  TypeChecker get _typeChecker =>
      TypeChecker.any(_annotations.map((e) => TypeChecker.fromRuntime(e)));

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final getters = <_SharedPrefEntry>{};

    _generateForAnnotation(library, getters);

    if (getters.isEmpty) return '';

    return '''
extension \$SharedPreferencesGenX on SharedPreferences {
 ${getters.map((getter) => getter.create()).join('\n')}
}
    ''';
  }

  void _generateForAnnotation(
    LibraryReader library,
    Set<_SharedPrefEntry> getters,
  ) {
    final keys = <String>{};
    for (final annotatedElement in library.annotatedWith(_typeChecker)) {
      final generatedValue = _generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
      );

      for (final value in generatedValue) {
        getters.add(value);
        final added = keys.add(value.key);
        if (!added) throw StateError('Duplicate key: ${value.key}');
      }
    }
  }

  List<_SharedPrefEntry> _generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
  ) {
    final entries = annotation.peek('entries')?.listValue ?? [];
    final sharedPrefEntries = <_SharedPrefEntry>[];

    for (final entry in entries) {
      final reader = ConstantReader(entry);

      // Generic type check
      final fullType =
          reader.objectValue.type!.getDisplayString(withNullability: false);
      final typeName = _extractGenericType(fullType);

      // Properties
      final key = reader.peek('key')!.stringValue;
      final defaultValue = reader.peek('defaultValue')?.literalValue;

      sharedPrefEntries.add(_SharedPrefEntry(
        key: key,
        defaultValue: defaultValue,
        typeName: typeName,
      ));
    }

    return sharedPrefEntries;
  }

  String _extractGenericType(String fullType) {
    final regex = RegExp(r'<(.+)>');
    final match = regex.firstMatch(fullType);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    }
    throw StateError('No generic type found in $fullType');
  }
}

class _SharedPrefEntry {
  const _SharedPrefEntry({
    required this.key,
    required this.defaultValue,
    required this.typeName,
  });

  final String key;
  final Object? defaultValue;
  final String typeName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _SharedPrefEntry &&
        other.key == key &&
        other.defaultValue == defaultValue &&
        other.typeName == typeName;
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, defaultValue, typeName);

  ({String getter, String setter}) get sharedPrefMethods {
    return switch (typeName) {
      'String' => (getter: 'getString', setter: 'setString'),
      'int' => (getter: 'getInt', setter: 'setInt'),
      'double' => (getter: 'getDouble', setter: 'setDouble'),
      'bool' => (getter: 'getBool', setter: 'setBool'),
      'List<String>' => (getter: 'getStringList', setter: 'setStringList'),
      _ => throw StateError('Unsupported type: $typeName'),
    };
  }

  String create() {
    final (:getter, :setter) = sharedPrefMethods;
    return '''
    SharedPrefValue<$typeName> get $key => SharedPrefValue<$typeName>(
      key: '$key',
      getter: $getter,
      setter: $setter,
      remover: remove,
      ${defaultValue != null ? 'defaultValue: $defaultValue,' : ''}
    );
    ''';
  }
}
