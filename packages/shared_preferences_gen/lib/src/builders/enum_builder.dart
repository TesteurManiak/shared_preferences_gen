part of 'gen_builder.dart';

class EnumBuilder extends GenBuilder {
  const EnumBuilder({
    required this.enumType,
  });

  final String enumType;

  static String nameGenerator(String enumType) {
    return '_\$${enumType}ConverterType';
  }

  String get name => nameGenerator(enumType);

  @override
  String build() {
    return '''
    const $name = EnumIndexAdapter<$enumType>($enumType.values);
    ''';
  }
}
