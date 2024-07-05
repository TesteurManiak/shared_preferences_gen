class DuplicateKeyException implements Exception {
  final String key;

  const DuplicateKeyException(this.key);

  @override
  String toString() => 'Duplicate key: $key';
}

class NoGenericTypeException implements Exception {
  const NoGenericTypeException();

  @override
  String toString() => 'No generic type found on SharedPrefData annotation.';
}
