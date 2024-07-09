import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:shared_preferences_gen/src/exceptions/exceptions.dart';
import 'package:shared_preferences_gen/src/templates/gen_template.dart';
import 'package:shared_preferences_gen/src/utils/shared_pref_entry_utils.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

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
  ${keys.isNotEmpty ? 'Set<SharedPrefValueGen> get entries => {${keys.join(', ')}};' : ''}

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
          case GetterTemplate():
            getters.add(value.build());
            final added = keys.add(value.key);
            if (!added) throw DuplicateKeyException(value.key);
          case EnumTemplate():
            converters.add(value.build());
        }
      }
    }
  }

  Iterable<GenTemplate> _generateForAnnotatedElement(
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
      final entryObj = entryForObject(entry);
      final adapter = _extractAdapter(dartType, reader);

      yield GetterTemplate(
        key: entryObj.key,
        isEnum: dartType.isEnumEntry,
        isSerializable: dartType.isSerializableEntry,
        accessor: entryObj.accessor,
        adapter: adapter,
        defaultValue: entryObj.defaultValue,
        defaultValueAsString: entryObj.defaultValueAsString,
        inputType: input,
        outputType: output,
      );

      if (dartType.isEnumEntry) yield EnumTemplate(enumType: output);
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
      _ => throw UnsupportedSharedPrefEntryValueType(dartType.fullTypeName),
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
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final argType]))
          when argType.isSerializable =>
        'SerializableAdapter<$argType>',
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
  bool get isSupportedBaseType => _spBaseTypes.contains(fullTypeName);

  bool get isEnumEntry {
    return switch ((typeName, this)) {
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final arg])) =>
        arg.isEnum,
      _ => false,
    };
  }

  bool get isSerializableEntry {
    return switch ((typeName, this)) {
      ('SharedPrefEntry', ParameterizedType(typeArguments: [final arg])) =>
        arg.isSerializable,
      _ => false,
    };
  }

  bool get isDateTime => fullTypeName == 'DateTime';

  bool get isSerializable {
    final classElement = element;
    if (classElement is! ClassElement) return false;

    final hasToJsonMethod =
        classElement.lookUpMethod('toJson', classElement.library) != null ||
            classElement.mixins.any((mixin) =>
                mixin.lookUpMethod2('toJson', classElement.library) != null);

    if (!hasToJsonMethod) return false;

    final hasFromJson = classElement.constructors.firstWhereOrNull((e) =>
        e.name == 'fromJson' &&
        e.isFactory &&
        e.parameters.length == 1 &&
        e.parameters.first.type.isDartCoreMap);

    return hasFromJson != null;
  }

  String get fullTypeName => getDisplayString(withNullability: true);
  String get typeName => fullTypeName.removeGenericTypes();
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
