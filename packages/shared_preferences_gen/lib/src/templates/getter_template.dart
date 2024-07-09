part of 'gen_template.dart';

class GetterTemplate extends GenTemplate {
  const GetterTemplate({
    required this.key,
    required this.isEnum,
    required this.isSerializable,
    required String? accessor,
    required this.adapter,
    required this.defaultValue,
    required this.inputType,
    required this.outputType,
  }) : accessor = accessor ?? key;

  final String key;
  final bool isEnum;
  final bool isSerializable;
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

  @override
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

    final valueType =
        defaultValue != null ? 'SharedPrefEntryWithDefault' : 'SharedPrefValue';

    return '''
    $valueType<$outputType> get $accessor {
      ${_buildAdapter()}
      return $valueType<$outputType>(
        key: '$key',
        getter: $getter,
        setter: $setter,
        remover: remove,
        ${defaultValue != null ? 'defaultValue: $defaultValue,' : ''}
      );
    }
    ''';
  }

  String _buildAdapter() {
    if (adapter == null) return '';
    if (isEnum) {
      return 'const adapter = ${EnumTemplate.nameGenerator(outputType)};';
    }
    if (isSerializable) {
      return '''final adapter = SerializableAdapter<$outputType>(
        fromJson: $outputType.fromJson,
        toJson: (v) => v.toJson(),
      );''';
    }
    return 'const adapter = $adapter();';
  }
}
