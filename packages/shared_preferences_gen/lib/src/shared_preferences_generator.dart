import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:shared_preferences_gen/src/exceptions/exceptions.dart';
import 'package:source_gen/source_gen.dart';

const _annotationsUrl =
    'package:shared_preferences_annotation/src/shared_pref_data.dart';

const _annotations = <String>{
  'SharedPrefData',
};

const _spBaseTypes = <String>{
  'String',
  'int',
  'double',
  'bool',
  'List<String>',
};

class SharedPreferencesGenerator extends Generator {
  const SharedPreferencesGenerator();

  TypeChecker get _typeChecker => TypeChecker.any(
      _annotations.map((e) => TypeChecker.fromUrl('$_annotationsUrl#$e')));

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final getters = <String>{};
    final adapters = <String>{};

    _generateForAnnotation(library, getters, adapters);

    if (getters.isEmpty) return '';

    return [
      '''
extension \$SharedPreferencesGenX on SharedPreferences {
 ${getters.map((getter) => getter).join('\n')}
}
    ''',
      ...adapters,
    ].join('\n\n');
  }

  void _generateForAnnotation(
    LibraryReader library,
    Set<String> getters,
    Set<String> adapters,
  ) {
    final keys = <String>{};
    for (final annotatedElement in library.annotatedWith(_typeChecker)) {
      final generatedValue = _generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
      );

      for (final value in generatedValue) {
        getters.add(value.build());
        final added = keys.add(value.key);
        if (!added) throw DuplicateKeyException(value.key);
      }
    }
  }

  List<_GetterBuilder> _generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
  ) {
    final entries = annotation.peek('entries')?.listValue ?? [];
    final sharedPrefEntries = <_GetterBuilder>[];

    for (final entry in entries) {
      final reader = ConstantReader(entry);

      // Generic type check
      final dartType = reader.objectValue.type;
      final (:output, :input) = _extractGenericTypes(dartType!);

      // Properties
      final key = reader.peek('key')!.stringValue;
      final accessor = reader.peek('accessor')?.stringValue;
      final defaultValue = reader.peek('defaultValue')?.literalValue;

      sharedPrefEntries.add(
        _GetterBuilder(
          key: key,
          accessor: accessor,
          defaultValue: defaultValue,
          inputType: input,
          outputType: output,
        ),
      );
    }

    return sharedPrefEntries;
  }

  ({String input, String output}) _extractGenericTypes(DartType dartType) {
    final typeName =
        dartType.getDisplayString(withNullability: false).removeGenericTypes();

    return switch ((typeName, dartType)) {
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final typeArg])) =>
        (
          input: typeArg.getDisplayString(withNullability: false),
          output: typeArg.getDisplayString(withNullability: false)
        ),
      (
        'CustomEntry',
        ParameterizedType(typeArguments: [final outputType, final inputType])
      ) =>
        (
          input: inputType.getDisplayString(withNullability: false),
          output: outputType.getDisplayString(withNullability: false)
        ),
      ('DateTimeEntry', _) => (input: 'int', output: 'DateTime'),
      _ => throw NoGenericTypeException(typeName),
    };
  }
}

class _GetterBuilder {
  const _GetterBuilder({
    required this.key,
    required String? accessor,
    required this.defaultValue,
    required this.inputType,
    required this.outputType,
  }) : accessor = accessor ?? key;

  final String key;
  final String accessor;
  final Object? defaultValue;
  final String inputType;
  final String outputType;

  ({String getter, String setter}) get sharedPrefMethods {
    return switch (inputType) {
      'String' => (getter: 'getString', setter: 'setString'),
      'int' => (getter: 'getInt', setter: 'setInt'),
      'double' => (getter: 'getDouble', setter: 'setDouble'),
      'bool' => (getter: 'getBool', setter: 'setBool'),
      'List<String>' => (getter: 'getStringList', setter: 'setStringList'),
      _ => throw StateError('Unsupported type: $inputType'),
    };
  }

  String build() {
    final (getter: spGetter, setter: spSetter) = sharedPrefMethods;
    final needsAdapter = !_spBaseTypes.contains(outputType);
    final (:getter, :setter) = switch (needsAdapter) {
      true => (
          getter: '(k) => adapter.fromSharedPrefs($spGetter(k))',
          setter: '(k, v) => $spSetter(k, adapter.toSharedPrefs(v))',
        ),
      false => (getter: spGetter, setter: spSetter),
    };

    return '''
    SharedPrefValue<$outputType> get $accessor {
      ${needsAdapter ? 'final adapter = SharedPrefData.getAdapter<$outputType, $inputType>();' : ''}
      return SharedPrefValue<$outputType>(
        key: '$key',
        getter: $getter,
        setter: $setter,
        remover: remove,
        ${defaultValue != null ? 'defaultValue: $defaultValue,' : ''}
      );
    }
    ''';
  }
}

extension on String {
  /// Remove generic types from a string. (e.g. `List<String>` -> `List`)
  String removeGenericTypes() {
    final regex = RegExp(r'<.*>');
    return replaceAll(regex, '');
  }
}
