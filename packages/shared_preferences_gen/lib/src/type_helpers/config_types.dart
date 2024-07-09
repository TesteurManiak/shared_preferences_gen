import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

/// Represents values from [SharedPrefEntry] when merged with local
/// configuration.
class SpEntryConfig {
  const SpEntryConfig({
    required this.key,
    required this.accessor,
    required this.defaultValue,
    required this.defaultValueAsString,
  });

  final String key;
  final String? accessor;
  final String? defaultValue;
  final String? defaultValueAsString;
}
