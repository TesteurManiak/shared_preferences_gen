import 'package:shared_preferences_annotation/src/shared_pref_entry.dart';

class SharedPrefData {
  const SharedPrefData(this.entries);

  final List<SharedPrefEntry> entries;
}
