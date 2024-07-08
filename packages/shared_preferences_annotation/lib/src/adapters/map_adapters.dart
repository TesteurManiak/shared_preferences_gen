import 'dart:convert';

import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

/// {@template map_adapter}
/// Implementation for a Map to String converter that uses the json
/// encoding/decoding as the value stored in the shared preferences.
/// {@endtemplate}
class MapAdapter extends TypeAdapter<Map<String, dynamic>, String> {
  /// {@macro map_adapter}
  const MapAdapter();

  @override
  Map<String, dynamic>? fromSharedPrefs(String? value) {
    if (value == null) return null;
    final decodedString = _tryDecode(value);
    if (decodedString is! Map<String, dynamic>) {
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
  String toSharedPrefs(Map<String, dynamic> value) => jsonEncode(value);
}
