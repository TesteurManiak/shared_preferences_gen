import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

class DefaultAdapter<T> extends TypeAdapter<T, T> {
  @override
  T? fromSharedPrefs(T? value) => value;

  @override
  T toSharedPrefs(T value) => value;
}
