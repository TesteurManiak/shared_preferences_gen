import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:shared_preferences_gen/src/builders/gen_builder.dart';
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
    final converters = <String>{};
    final keys = <String>{};

    _generateForAnnotation(
      library: library,
      getters: getters,
      converters: converters,
      keys: keys,
    );

    if (getters.isEmpty) return '';

    return [
      '''
extension \$SharedPreferencesGenX on SharedPreferences {
  ${keys.isNotEmpty ? 'Set<SharedPrefValue> get entries => {${keys.join(', ')}};' : ''}

  ${getters.map((getter) => getter).join('\n')}
}
    ''',
      ...converters,
    ].join('\n\n');
  }

  void _generateForAnnotation({
    required LibraryReader library,
    required Set<String> getters,
    required Set<String> converters,
    required Set<String> keys,
  }) {
    for (final annotatedElement in library.annotatedWith(_typeChecker)) {
      final generatedValue = _generateForAnnotatedElement(
        annotatedElement.element,
        annotatedElement.annotation,
      );

      for (final value in generatedValue) {
        switch (value) {
          case GetterBuilder():
            getters.add(value.build());
            final added = keys.add(value.key);
            if (!added) throw DuplicateKeyException(value.key);
          case EnumBuilder():
            converters.add(value.build());
        }
      }
    }
  }

  Iterable<GenBuilder> _generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
  ) sync* {
    final entries = annotation.peek('entries')?.listValue ?? [];

    for (final entry in entries) {
      final reader = ConstantReader(entry);

      // Generic type check
      final dartType = reader.objectValue.type;
      final (:output, :input) = _extractGenericTypes(dartType!);

      // Properties
      final key = reader.peek('key')!.stringValue;
      final accessor = reader.peek('accessor')?.stringValue;
      final defaultValue = _parseValue(reader.peek('defaultValue'));
      final adapter = _extractAdapter(dartType, reader);

      yield GetterBuilder(
        key: key,
        isEnum: dartType.isEnumEntry,
        accessor: accessor,
        adapter: adapter,
        defaultValue: defaultValue,
        inputType: input,
        outputType: output,
      );

      if (dartType.isEnumEntry) yield EnumBuilder(enumType: output);
    }
  }

  ({String input, String output}) _extractGenericTypes(DartType dartType) {
    final typeName = dartType.typeName;

    return switch ((typeName, dartType)) {
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final typeArg]))
          when typeArg.isSupportedBaseType =>
        (input: typeArg.fullTypeName, output: typeArg.fullTypeName),
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final typeArg]))
          when typeArg.isDateTime =>
        (input: 'int', output: typeArg.fullTypeName),
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final typeArg]))
          when typeArg.isEnum =>
        (input: 'int', output: typeArg.fullTypeName),
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final typeArg]))
          when typeArg.isSerializable =>
        (input: 'String', output: typeArg.fullTypeName),
      (
        'CustomEntry',
        ParameterizedType(typeArguments: [final outputType, final inputType])
      ) =>
        (input: inputType.fullTypeName, output: outputType.fullTypeName),
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
      _ when reader.isEnum => reader.enumValue,
      _ => reader.objectValue,
    };

    return _encodeToString(value);
  }

  String? _encodeToString(Object? value) {
    return switch (value) {
      null => null,
      List() => "[${value.map((e) => _encodeToString(e)).join(', ')}]",
      Set() => "{${value.map((e) => _encodeToString(e)).join(', ')}}",
      Map() =>
        "{${value.entries.map((e) => '${_encodeToString(e.key)}: ${_encodeToString(e.value)}').join(', ')}}",
      _ => value.toString(),
    };
  }

  String? _extractAdapter(DartType dartType, ConstantReader reader) {
    final adapterField = reader.peek('adapter')?.objectValue.type?.fullTypeName;
    if (adapterField != null) return adapterField;

    final typeName = dartType.typeName;
    return switch ((typeName, dartType)) {
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final argType]))
          when argType.isDateTime =>
        'DateTimeMillisecondAdapter',
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final enumType]))
          when enumType.isEnum =>
        'EnumAdapter<$enumType>',
      _ => null,
    };
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
  bool get isSupportedBaseType {
    final typeName = getDisplayString(withNullability: false);
    return _spBaseTypes.contains(typeName);
  }

  bool get isEnumEntry {
    return switch ((typeName, this)) {
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final arg])) =>
        arg.isEnum,
      _ => false,
    };
  }

  bool get isEnum => element?.kind == ElementKind.ENUM;
  bool get isDateTime => getDisplayString(withNullability: false) == 'DateTime';

  bool get isSerializable {
    final classElement = element;
    if (classElement is! ClassElement) return false;

    final hasToJson = classElement.methods
        .firstWhereOrNull((e) => e.name == 'toJson' && e.parameters.isEmpty);
    if (hasToJson == null) return false;

    final hasFromJson = classElement.constructors.firstWhereOrNull((e) =>
        e.name == 'fromJson' &&
        e.isFactory &&
        e.parameters.length == 1 &&
        e.parameters.first.type.isDartCoreMap);

    return hasFromJson != null;
  }

  String get fullTypeName => getDisplayString(withNullability: false);
  String get typeName => fullTypeName.removeGenericTypes();
}

extension on ConstantReader {
  bool get isEnum => objectValue.type?.isEnum ?? false;

  String get enumValue {
    if (!isEnum) throw Exception('Not an enum value');

    final enumClassName =
        objectValue.type!.getDisplayString(withNullability: false);
    final enumValueName = objectValue.getField('_name')!.toStringValue();

    return '$enumClassName.$enumValueName';
  }
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
