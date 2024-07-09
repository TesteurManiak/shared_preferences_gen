part of 'gen_template.dart';

typedef _SpMethods = ({String spGetter, String spSetter});

class GetterTemplate extends GenTemplate {
  const GetterTemplate({
    required this.key,
    required this.isEnum,
    required this.isSerializable,
    required String? accessor,
    required this.adapter,
    required this.defaultValue,
    required this.defaultValueAsString,
    required this.inputType,
    required this.outputType,
  }) : accessor = accessor ?? key;

  final String key;
  final bool isEnum;
  final bool isSerializable;
  final String accessor;
  final String? adapter;
  final String? defaultValue;
  final String? defaultValueAsString;
  final String inputType;
  final String outputType;

  static const _spMethods = <String, _SpMethods>{
    'String': (spGetter: 'getString', spSetter: 'setString'),
    'int': (spGetter: 'getInt', spSetter: 'setInt'),
    'double': (spGetter: 'getDouble', spSetter: 'setDouble'),
    'bool': (spGetter: 'getBool', spSetter: 'setBool'),
    'List<String>': (spGetter: 'getStringList', spSetter: 'setStringList'),
  };

  _SpMethods get _sharedPrefMethods => _spMethods[inputType]!;

  @override
  String build() {
    final (:spGetter, :spSetter) = _sharedPrefMethods;
    final hasDefault = defaultValue != null || defaultValueAsString != null;
    final (:getter, :setter) = switch (adapter != null) {
      true => (
          getter: '(k) => adapter.fromSharedPrefs($spGetter(k))',
          setter: '(k, v) => $spSetter(k, adapter.toSharedPrefs(v))',
        ),
      false => (getter: spGetter, setter: spSetter),
    };

    final valueType = 'SharedPrefValue${hasDefault ? 'WithDefault' : ''}';

    return '''
    $valueType<$outputType> get $accessor {
      ${_buildAdapter()}
      return $valueType<$outputType>(
        key: '$key',
        getter: $getter,
        setter: $setter,
        remover: remove,
        ${hasDefault ? 'defaultValue: ${defaultValue ?? defaultValueAsString},' : ''}
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
