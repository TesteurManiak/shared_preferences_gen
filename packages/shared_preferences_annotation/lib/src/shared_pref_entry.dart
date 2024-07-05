class SharedPrefEntry<T extends Object> {
  const SharedPrefEntry({
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
