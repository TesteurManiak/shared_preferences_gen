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

    // TODO: implement generate

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
    for (final annotatedElement in library.annotatedWith(_typeChecker)) {
      final generatedValue = _generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
      );

      // TODO: implement generateForAnnotation
      for (final value in generatedValue) {
        final added = getters.add(value);
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
        type: typeName,
      ));
    }

    // TODO: implement _generateForAnnotatedElement
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
    required this.type,
  });

  final String key;
  final Object? defaultValue;
  final String type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _SharedPrefEntry &&
        other.key == key &&
        other.defaultValue == defaultValue &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, defaultValue, type);

  String get sharedPrefGetter {
    return switch (type) {
      'String' => 'getString',
      'int' => 'getInt',
      'double' => 'getDouble',
      'bool' => 'getBool',
      _ => throw StateError('Unknown type: $type'),
    };
  }

  String get sharedPrefSetter {
    return switch (type) {
      'String' => 'setString',
      'int' => 'setInt',
      'double' => 'setDouble',
      'bool' => 'setBool',
      _ => throw StateError('Unknown type: $type'),
    };
  }

  String create() {
    return '''
    SharedPrefValue<$type> get $key => SharedPrefValue<$type>(
      key: '$key',
      getter: $sharedPrefGetter,
      setter: $sharedPrefSetter,
      remover: remove,
      ${defaultValue != null ? 'defaultValue: $defaultValue,' : ''}
    );
    ''';
  }
}
