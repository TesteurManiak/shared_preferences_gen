class DuplicateKeyException implements Exception {
  final String key;

  const DuplicateKeyException(this.key);

  @override
  String toString() => 'Duplicate key: $key';
}

class NoGenericTypeException implements Exception {
  const NoGenericTypeException(this.type);

  final String type;

  @override
  String toString() => 'No generic type found on $type object.';
}

class UnsupportedSharedPrefEntryType implements Exception {
  const UnsupportedSharedPrefEntryType(this.type);

  final String type;

  @override
  String toString() {
    return switch (type) {
      'DateTime' => 'Unsupported type: $type. Use DateTimeEntry instead.',
      _ =>
        'Unsupported type: $type. Use CustomEntry<$type, S> instead with a custom type adapter.',
    };
  }
}

class UnsupportedSharedPrefEntryValueType implements Exception {
  const UnsupportedSharedPrefEntryValueType(this.type);

  final String type;

  @override
  String toString() {
    return 'Unsupported value type: $type. Use a supported type instead.';
  }
}
