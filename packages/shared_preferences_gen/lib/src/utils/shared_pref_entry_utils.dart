import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:shared_preferences_gen/src/type_helpers/config_types.dart';
import 'package:shared_preferences_gen/src/utils/parsing_utils.dart';
import 'package:source_gen/source_gen.dart';

SpEntryConfig entryForObject(DartObject obj) => _from(obj);

SpEntryConfig _from(DartObject obj) {
  final objReader = ConstantReader(obj);

  /// Returns a literal value for [dartObject] if possible, otherwise throws
  /// an [InvalidGenerationSourceError] using [typeInformation] to describe
  /// the unsupported type.
  Object? literalForObject(
    String fieldName,
    DartObject dartObject,
    Iterable<String> typeInformation,
  ) {
    if (dartObject.isNull) return null;

    final reader = ConstantReader(dartObject);

    String? badType;
    if (reader.isSymbol) {
      badType = 'Symbol';
    } else if (reader.isType) {
      badType = 'Type';
    } else if (dartObject.type is FunctionType) {
      badType = 'Function';
    } else if (!reader.isLiteral) {
      badType = dartObject.type!.element?.name;
    }

    if (badType != null) {
      badType = typeInformation.followedBy([badType]).join(' > ');
      throw Exception(
        'Invalid value for `$fieldName`, is `$badType`, it must be a literal.',
      );
    }

    if (reader.isDouble || reader.isInt || reader.isString || reader.isBool) {
      return reader.literalValue;
    }

    if (reader.isList) {
      return [
        for (final e in reader.listValue)
          literalForObject(
            fieldName,
            e,
            [...typeInformation, 'List'],
          ),
      ];
    }

    if (reader.isSet) {
      return {
        for (final e in reader.setValue)
          literalForObject(
            fieldName,
            e,
            [...typeInformation, 'Set'],
          ),
      };
    }

    if (reader.isMap) {
      final mapTypeInformation = [
        ...typeInformation,
        'Map',
      ];
      return reader.mapValue.map(
        (k, v) => MapEntry(
          literalForObject(fieldName, k!, mapTypeInformation),
          literalForObject(fieldName, v!, mapTypeInformation),
        ),
      );
    }

    badType = typeInformation.followedBy(['$dartObject']).join(' > ');

    throw Exception(
      'The provided value is not supported. '
      'Please rerun your build with `--verbose` and file an issue.',
    );
  }

  /// Returns a literal object representing the value of [fieldName] in [obj].
  ///
  /// If [mustBeEnum] is `true`, throws an [InvalidGenerationSourceError] if
  /// either the annotated field is not an `enum` or `List` or if the value in
  /// [fieldName] is not an `enum` value.
  String? createAnnotationValue(String fieldName) {
    final value = objReader.read(fieldName);
    if (value.isNull) return null;

    final objectValue = value.objectValue;
    final type = objectValue.type!;

    if (type is FunctionType) {
      final functionValue = objectValue.toFunctionValue()!;
      final invokeConst =
          functionValue is ConstructorElement && functionValue.isConst
              ? 'const '
              : '';
      return '$invokeConst${functionValue.qualifiedName}()';
    }

    final enumFields = iterateEnumFields(type);

    if (enumFields != null) {
      final enumValueNames =
          enumFields.map((e) => e.name).toList(growable: false);
      final enumValueName =
          enumValueForDartObject<String>(objectValue, enumValueNames);
      return '${type.element!.name}.$enumValueName';
    } else {
      final defaultValueLiteral = literalForObject(fieldName, objectValue, []);
      if (defaultValueLiteral == null) return null;

      return jsonLiteralAsDart(defaultValueLiteral);
    }
  }

  final defaultValue = createAnnotationValue('defaultValue');

  return SpEntryConfig(
    key: objReader.read('key').stringValue,
    accessor: objReader.peek('accessor')?.stringValue,
    defaultValue: defaultValue,
    defaultValueAsString: objReader.peek('defaultValueAsString')?.stringValue,
  );
}

extension on ExecutableElement {
  String get qualifiedName {
    return switch (this) {
      FunctionElement() => name,
      MethodElement() => '${enclosingElement.name}.$name',
      ConstructorElement() when name.isEmpty => '${enclosingElement.name}',
      ConstructorElement() => '${enclosingElement.name}.$name',
      _ => throw UnsupportedError(
          'Not sure how to support typeof $runtimeType',
        ),
    };
  }
}

T enumValueForDartObject<T>(
  DartObject source,
  List<T> items,
) {
  return items[source.getField('index')!.toIntValue()!];
}
