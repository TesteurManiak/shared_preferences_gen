import 'package:shared_preferences_annotation/src/shared_pref_entry.dart';

/// {@template shared_pref_data}
/// Entrypoint used to specify shared preferences entries that will be
/// generated.
/// {@endtemplate}
class SharedPrefData {
  /// {@macro shared_pref_data}
  const SharedPrefData({required this.entries});

  /// List of shared preferences entries to generate.
  final List<EntryGen> entries;
}
