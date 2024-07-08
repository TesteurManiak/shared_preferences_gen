import 'dart:convert';

import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

/// {@template map_adapter}
/// Implementation for a Map to String converter that uses the json
/// encoding/decoding as the value stored in the shared preferences.
/// {@endtemplate}
class MapAdapter<K, V> extends TypeAdapter<Map<K, V>, String> {
  /// {@macro map_adapter}
  const MapAdapter();

  @override
  Map<K, V>? fromSharedPrefs(String? value) {
    if (value == null) return null;
    final decodedString = _tryDecode(value);
    if (decodedString is! Map<K, V>) {
      throw Exception('Invalid Map: "$decodedString"');
    }
    return decodedString;
  }

  Object? _tryDecode(String value) {
    try {
      return jsonDecode(value);
    } on FormatException {
      return null;
    }
  }

  @override
  String toSharedPrefs(Map<K, V> value) => jsonEncode(value);
}
