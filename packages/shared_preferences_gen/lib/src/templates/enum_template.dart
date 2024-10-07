part of 'gen_template.dart';

class EnumTemplate extends GenTemplate {
  const EnumTemplate({
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
    const $name = $enumIndexAdapterClassName<$enumType>($enumType.values);
    ''';
  }
}
