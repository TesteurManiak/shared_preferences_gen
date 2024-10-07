import 'dart:convert';

import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

const serializableAdapterClassName = r'$SerializableAdapter';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef ToJson<T> = Map<String, dynamic> Function(T value);

class $SerializableAdapter<T extends Object> extends TypeAdapter<T, String> {
  const $SerializableAdapter({
    required this.fromJson,
    required this.toJson,
  });

  final FromJson<T> fromJson;
  final ToJson<T> toJson;

  @override
  T? fromSharedPrefs(String? value) {
    if (value == null) return null;
    final decodedString = _tryDecode(value);
    if (decodedString is! Map<String, dynamic>) {
      throw Exception('Invalid Map: "$decodedString"');
    }
    return fromJson(decodedString);
  }

  Object? _tryDecode(String value) {
    try {
      return jsonDecode(value);
    } on FormatException {
      return null;
    }
  }

  @override
  String toSharedPrefs(T value) => jsonEncode(toJson(value));
}
