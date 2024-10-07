import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

part 'enum_template.dart';
part 'getter_template.dart';

sealed class GenTemplate {
  const GenTemplate();

  String build();
}
