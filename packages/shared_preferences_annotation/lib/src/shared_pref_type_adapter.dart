/// {@template shared_pref_type_adapter}
/// Implement this class to provide custom converters for a specific [Type].
///
/// [T] is the data type you'd like to convert to and from.
///
/// [S] is the type of the value that is stored in the shared preferences.
///
/// Custom converters should be registered with:
/// ```dart
/// SharedPrefGenUtils.registerAdapter(MyObjectAdapter());
/// ```
/// {@endtemplate}
abstract class SharedPrefTypeAdapter<T, S> {
  /// {@macro shared_pref_type_adapter}
  const SharedPrefTypeAdapter();

  T encode(S value);
  S decode(T value);
}
