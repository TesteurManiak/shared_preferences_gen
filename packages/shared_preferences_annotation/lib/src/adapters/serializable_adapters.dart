import 'package:shared_preferences_annotation/src/adapters/map_adapters.dart';
import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, dynamic> Function(T value);

class SerializableAdapter<T extends Object> extends TypeAdapter<T, String> {
  const SerializableAdapter({
    required this.fromJson,
    required this.toJson,
  });

  final FromJson<T> fromJson;
  final ToJson<T> toJson;

  static const _mapAdapter = MapAdapter();

  @override
  T? fromSharedPrefs(String? value) {
    final decodedMap = _mapAdapter.fromSharedPrefs(value);
    if (decodedMap == null) return null;
    return fromJson(decodedMap);
  }

  @override
  String toSharedPrefs(T value) {
    final map = toJson(value);
    return _mapAdapter.toSharedPrefs(map);
  }
}
