sealed class EntryGen<T extends Object, S> {
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

class SharedPrefEntry<T extends Object> extends EntryGen<T, T> {
  const SharedPrefEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}

class CustomEntry<T extends Object, S> extends EntryGen<T, S> {
  const CustomEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}

class DateTimeEntry extends CustomEntry<DateTime, int> {
  const DateTimeEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}
