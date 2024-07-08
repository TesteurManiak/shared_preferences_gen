import 'package:shared_preferences_annotation/src/adapters/date_time_adapters.dart';
import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';
import 'package:shared_preferences_annotation/src/shared_pref_entry.dart';

class SharedPrefData {
  const SharedPrefData({required this.entries});

  final List<EntryGen> entries;

  static final _adapters = <String, TypeAdapter>{
    'DateTime': DateTimeMillisecondAdapter(),
  };

  static void registerAdapter<T>(TypeAdapter<T, dynamic> adapter) {
    _adapters[T.toString()] ??= adapter;
  }

  static TypeAdapter<T, S> getAdapter<T, S>() {
    final adapter = _adapters[T.toString()];
    if (adapter == null || adapter is! TypeAdapter<T, S>) {
      throw Exception('Adapter not found for type $T');
    }
    return adapter;
  }
}
