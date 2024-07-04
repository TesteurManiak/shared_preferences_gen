import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

/// {@template enum_index_adapter}
/// Implementation for an enum to int converter that uses the index of the enum
/// as the value stored in the shared preferences.
/// {@endtemplate}
class EnumIndexAdapter<T extends Enum> extends TypeAdapter<T, int> {
  /// {@macro enum_index_adapter}
  const EnumIndexAdapter(this.values);

  /// All values of the enum.
  final List<T> values;

  @override
  T fromSharedPrefs(int value) => values[value];

  @override
  int toSharedPrefs(T value) => value.index;
}
