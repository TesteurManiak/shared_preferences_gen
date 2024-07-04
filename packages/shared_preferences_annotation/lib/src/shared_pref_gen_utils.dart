import 'package:shared_preferences_annotation/src/shared_pref_type_adapter.dart';

class SharedPrefGenUtils {
  SharedPrefGenUtils._();

  static void registerAdapter<T>(SharedPrefTypeAdapter<T, Object?> adapter) {
    if (_typeAdapters.containsKey(T)) {
      throw StateError('Adapter for type $T already registered');
    }
    _typeAdapters[T] = adapter;
  }

  static SharedPrefTypeAdapter<T, S> getAdapter<T, S>() {
    final adapter = _typeAdapters[T] as SharedPrefTypeAdapter<T, S>?;
    if (adapter == null) {
      throw StateError('Adapter for type $T not found');
    }
    return adapter;
  }

  static final _typeAdapters = <Type, SharedPrefTypeAdapter>{
    // Default adapters
    String: const _DefaultAdapter<String>(),
    int: const _DefaultAdapter<int>(),
    double: const _DefaultAdapter<double>(),
    bool: const _DefaultAdapter<bool>(),
    List<String>: const _DefaultAdapter<List<String>>(),
  };
}

class _DefaultAdapter<T> extends SharedPrefTypeAdapter<T, T> {
  const _DefaultAdapter();

  @override
  T decode(T value) => value;

  @override
  T encode(T value) => value;
}
