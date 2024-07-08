part 'enum_builder.dart';
part 'getter_builder.dart';

sealed class GenBuilder {
  const GenBuilder();

  String build();
}
