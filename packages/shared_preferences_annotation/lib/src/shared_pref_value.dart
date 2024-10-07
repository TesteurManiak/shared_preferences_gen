const spValueGenClassName = r'$SharedPrefValueGen';
const spValueClassName = r'$SharedPrefValue';

typedef SharedPrefGetter<T> = T? Function(String key);
typedef SharedPrefSetter<T> = Future<bool> Function(String key, T value);
typedef SharedPrefRemover = Future<bool> Function(String key);

/// Base class for shared preference entries.
sealed class $SharedPrefValueGen<T> {
  const $SharedPrefValueGen({
    required SharedPrefGetter<T> getter,
    required SharedPrefSetter<T> setter,
    required SharedPrefRemover remover,
    required this.key,
  })  : _getter = getter,
        _setter = setter,
        _remover = remover;

  final SharedPrefGetter<T> _getter;
  final SharedPrefSetter<T> _setter;
  final SharedPrefRemover _remover;
  final String key;

  /// Decoded value, stored in shared preferences.
  T? get value => _getter(key);

  /// Set value to shared preferences.
  Future<bool> setValue(T value) => _setter(key, value);

  /// Remove value from shared preferences.
  Future<bool> remove() => _remover(key);

  @override
  String toString() => value.toString();
}

/// Represents a shared preference entry with no default value.
///
/// The [value] getter will return `null` if the value is not found in shared
/// preferences.
class $SharedPrefValue<T> extends $SharedPrefValueGen<T> {
  const $SharedPrefValue({
    required super.getter,
    required super.setter,
    required super.remover,
    required super.key,
  });
}

/// Represents a shared preference entry with a default value.
///
/// The [value] getter will return the [defaultValue] if the value is not found
/// in shared preferences.
class $SharedPrefValueWithDefault<T extends Object>
    extends $SharedPrefValueGen<T> {
  const $SharedPrefValueWithDefault({
    required super.getter,
    required super.setter,
    required super.remover,
    required super.key,
    required this.defaultValue,
  });

  final T defaultValue;

  @override
  T get value => _getter(key) ?? defaultValue;
}
