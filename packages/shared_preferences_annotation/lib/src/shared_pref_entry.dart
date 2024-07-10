import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

sealed class EntryGen<T extends Object, S> {
  const EntryGen({
    required this.key,
    this.accessor,
    this.defaultValue,
    this.defaultValueAsString,
    this.adapter,
  }) : assert(defaultValue == null || defaultValueAsString == null);

  /// Unique key for the entry.
  final String key;

  /// Name of the getter.
  ///
  /// If not provided, the getter will be generated from the key.
  final String? accessor;

  /// Default value for the entry.
  ///
  /// This value cannot be specified for non-literal types.
  ///
  /// You cannot specify both [defaultValue] and [defaultValueAsString].
  final T? defaultValue;

  /// Default value for the entry as a string.
  ///
  /// This is useful for types that can't be represented as a literal in Dart.
  ///
  /// You cannot specify both [defaultValue] and [defaultValueAsString].
  final String? defaultValueAsString;

  final TypeAdapter<T, S>? adapter;
}

/// {@template shared_pref_entry}
/// Entry for a shared preference.
///
/// Can be used with any of the base supported types of shared preferences:
/// - `bool`
/// - `double`
/// - `int`
/// - `String`
/// - `List<String>`
/// {@endtemplate}
final class SharedPrefEntry<T extends Object> extends EntryGen<T, T> {
  /// {@macro shared_pref_entry}
  const SharedPrefEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
    super.defaultValueAsString,
  });
}

/// {@template custom_entry}
/// Entry for a custom shared preference type.
///
/// You'll need to provide a custom type adapter to convert the type to a
/// supported shared preference type.
/// {@endtemplate}
final class CustomEntry<T extends Object, S> extends EntryGen<T, S> {
  /// {@macro custom_entry}
  const CustomEntry({
    required super.key,
    required TypeAdapter<T, S> super.adapter,
    super.accessor,
    super.defaultValue,
    super.defaultValueAsString,
  });
}
