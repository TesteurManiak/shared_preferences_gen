sealed class EntryGen<T extends Object> {
  const EntryGen({
    required this.key,
    this.accessor,
    this.defaultValue,
  });

  /// Unique key for the entry.
  final String key;

  /// Name of the getter.
  ///
  /// If not provided, the getter will be generated from the key.
  final String? accessor;

  /// Default value for the entry.
  final T? defaultValue;
}

class SharedPrefEntry<T extends Object> extends EntryGen<T> {
  const SharedPrefEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}

class CustomEntry<T extends Object, S> extends EntryGen<T> {
  const CustomEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}
