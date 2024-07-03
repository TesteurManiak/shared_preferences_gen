class SharedPrefEntry<T extends Object> {
  const SharedPrefEntry({
    required this.key,
    this.defaultValue,
  });

  /// Unique key for the entry.
  final String key;

  /// Default value for the entry.
  final T? defaultValue;
}
