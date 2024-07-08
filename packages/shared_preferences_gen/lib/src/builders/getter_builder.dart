part of 'gen_builder.dart';

class GetterBuilder extends GenBuilder {
  const GetterBuilder({
    required this.key,
    required this.isEnum,
    required String? accessor,
    required this.adapter,
    required this.defaultValue,
    required this.inputType,
    required this.outputType,
  }) : accessor = accessor ?? key;

  final String key;
  final bool isEnum;
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

    return '''
    SharedPrefValue<$outputType> get $accessor {
      ${_buildAdapter()}
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

  String _buildAdapter() {
    if (adapter == null) return '';
    if (isEnum) {
      return 'const adapter = ${EnumBuilder.nameGenerator(outputType)};';
    }
    return 'const adapter = $adapter();';
  }
}
