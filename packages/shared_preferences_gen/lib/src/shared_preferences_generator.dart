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
    final keys = <String>{};

    _generateForAnnotation(library, getters, keys);

    if (getters.isEmpty) return '';

    return [
      '''
extension \$SharedPreferencesGenX on SharedPreferences {
  ${keys.isNotEmpty ? 'Set<String> get keys => {${[
          ...keys.map((k) => "'$k'")
        ].join(', ')}};' : ''}

  ${getters.map((getter) => getter).join('\n')}
}
    ''',
    ].join('\n\n');
  }

  void _generateForAnnotation(
    LibraryReader library,
    Set<String> getters,
    Set<String> keys,
  ) {
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

      // Get the default value from the element in the "defaultValue" field.
      final defaultValue = _parseValue(reader.peek('defaultValue'));

      final adapter = reader
          .peek('adapter')
          ?.objectValue
          .type
          ?.getDisplayString(withNullability: false);

      sharedPrefEntries.add(
        _GetterBuilder(
          key: key,
          accessor: accessor,
          adapter: adapter,
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
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final typeArg]))
          when typeArg.isSupportedSharedPrefType =>
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
      ('MapEntry', _) => (input: 'String', output: 'Map<String, dynamic>'),
      _ => throw NoGenericTypeException(typeName),
    };
  }

  String? _parseValue(ConstantReader? reader) {
    if (reader == null || reader.isNull) return null;

    final value = switch (reader) {
      _ when reader.isString => '"${reader.stringValue}"',
      _ when reader.isInt => reader.intValue,
      _ when reader.isDouble => reader.doubleValue,
      _ when reader.isBool => reader.boolValue,
      _ when reader.isList =>
        reader.listValue.map((e) => _parseValue(ConstantReader(e))).toList(),
      _ when reader.isSet =>
        reader.setValue.map((e) => _parseValue(ConstantReader(e))).toSet(),
      _ when reader.isMap => reader.mapValue.map((k, v) {
          return MapEntry(
              _parseValue(ConstantReader(k)), _parseValue(ConstantReader(v)));
        }),
      _ => null,
    };

    return _encodeToString(value);
  }

  String? _encodeToString(Object? value) {
    return switch (value) {
      null => null,
      String() => value,
      List() => "[${value.map((e) => _encodeToString(e)).join(', ')}]",
      Set() => "{${value.map((e) => _encodeToString(e)).join(', ')}}",
      Map() =>
        "{${value.entries.map((e) => '${_encodeToString(e.key)}: ${_encodeToString(e.value)}').join(', ')}}",
      _ => value.toString(),
    };
  }
}

class _GetterBuilder {
  const _GetterBuilder({
    required this.key,
    required String? accessor,
    required this.adapter,
    required this.defaultValue,
    required this.inputType,
    required this.outputType,
  }) : accessor = accessor ?? key;

  final String key;
  final String accessor;
  final String? adapter;
  final String? defaultValue;
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
    final hasAdapter = adapter != null;
    final (:getter, :setter) = switch (hasAdapter) {
      true => (
          getter: '(k) => adapter.fromSharedPrefs($spGetter(k))',
          setter: '(k, v) => $spSetter(k, adapter.toSharedPrefs(v))',
        ),
      false => (getter: spGetter, setter: spSetter),
    };

    return '''
    SharedPrefValue<$outputType> get $accessor {
      ${hasAdapter ? 'const adapter = $adapter();' : ''}
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

extension on DartType {
  bool get isSupportedSharedPrefType {
    final typeName = getDisplayString(withNullability: false);
    return _spBaseTypes.contains(typeName);
  }
}
