abstract class TypeAdapter<T, S> {
  const TypeAdapter();

  /// Converts a value from shared preferences [S] to a Dart object [T].
  T? fromSharedPrefs(S? value);

  /// Converts a Dart object [T] to a value that can be stored in shared
  /// preferences [S].
  S toSharedPrefs(T value);
}
