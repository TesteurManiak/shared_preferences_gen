import 'package:shared_preferences_gen/src/builders/gen_builder.dart';
import 'package:source_helper/source_helper.dart';

class EnumBuilder extends GenBuilder {
  const EnumBuilder({
    required this.enumType,
  });

  final String enumType;

  static String nameGenerator(String enumType) {
    return '_${enumType.pascal}Converter';
  }

  String get name => nameGenerator(enumType);

  @override
  String build() {
    return '''
    final $name = EnumAdapter<$enumType>($enumType.values);
    ''';
  }
}
