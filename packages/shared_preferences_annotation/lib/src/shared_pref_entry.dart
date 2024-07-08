import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

sealed class EntryGen<T extends Object, S> {
  const EntryGen({
    required this.key,
    this.accessor,
    this.defaultValue,
    this.adapter,
  });

  /// Unique key for the entry.
  final String key;

  /// Name of the getter.
  ///
  /// If not provided, the getter will be generated from the key.
  final String? accessor;

  /// Default value for the entry.
  final T? defaultValue;

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
class SharedPrefEntry<T extends Object> extends EntryGen<T, T> {
  /// {@macro shared_pref_entry}
  const SharedPrefEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}

/// {@template custom_entry}
/// Entry for a custom shared preference type.
///
/// You'll need to provide a custom type adapter to convert the type to a
/// supported shared preference type.
/// {@endtemplate}
class CustomEntry<T extends Object, S> extends EntryGen<T, S> {
  /// {@macro custom_entry}
  const CustomEntry({
    required super.key,
    required TypeAdapter<T, S> super.adapter,
    super.accessor,
    super.defaultValue,
  });
}

/// {@template date_time_entry}
/// Entry for a shared preference of type `DateTime`.
///
/// It will be stored as an `int` in the shared preferences.
/// {@endtemplate}
class DateTimeEntry extends CustomEntry<DateTime, int> {
  const DateTimeEntry({
    required super.key,
    super.accessor,
  }) : super(adapter: const DateTimeMillisecondAdapter());
}

// TODO(Guillaume): use a better name to avoid conflicts with MapEntry from the Dart SDK.
class MapEntry<K, V> extends EntryGen<Map<K, V>, String> {
  const MapEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}

class EnumEntry<T extends Enum> extends EntryGen<T, int> {
  const EnumEntry({
    required super.key,
    super.accessor,
    super.defaultValue,
  });
}
