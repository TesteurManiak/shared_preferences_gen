import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

const dateTimeMillisecondAdapterClassName = r'$DateTimeMillisecondAdapter';

/// {@template date_time_millisecond_adapter}
/// Implementation for a DateTime to int converter that uses the milliseconds
/// since epoch as the value stored in the shared preferences.
/// {@endtemplate}
class $DateTimeMillisecondAdapter extends TypeAdapter<DateTime, int> {
  /// {@macro date_time_millisecond_adapter}
  const $DateTimeMillisecondAdapter();

  @override
  DateTime? fromSharedPrefs(int? value) {
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  @override
  int toSharedPrefs(DateTime value) => value.millisecondsSinceEpoch;
}
