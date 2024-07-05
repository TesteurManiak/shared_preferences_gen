typedef SharedPrefGetter<T> = T? Function(String key);
typedef SharedPrefSetter<T> = Future<bool> Function(String key, T value);
typedef SharedPrefRemover = Future<bool> Function(String key);

class SharedPrefValue<T extends Object> {
  const SharedPrefValue({
    required SharedPrefGetter<T> getter,
    required SharedPrefSetter<T> setter,
    required SharedPrefRemover remover,
    required this.key,
    this.defaultValue,
  })  : _getter = getter,
        _setter = setter,
        _remover = remover;

  final SharedPrefGetter<T> _getter;
  final SharedPrefSetter<T> _setter;
  final SharedPrefRemover _remover;
  final String key;
  final T? defaultValue;

  T? get value => _getter(key) ?? defaultValue;
  Future<bool> setValue(T value) => _setter(key, value);
  Future<bool> remove() => _remover(key);

  @override
  String toString() => value.toString();
}
