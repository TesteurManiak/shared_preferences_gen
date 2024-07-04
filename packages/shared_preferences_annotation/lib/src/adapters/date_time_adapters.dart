import 'package:shared_preferences_annotation/src/adapters/type_adapter.dart';

/// {@template date_time_millisecond_adapter}
/// Implementation for a DateTime to int converter that uses the milliseconds
/// since epoch as the value stored in the shared preferences.
/// {@endtemplate}
class DateTimeMillisecondAdapter extends TypeAdapter<DateTime, int> {
  /// {@macro date_time_millisecond_adapter}
  const DateTimeMillisecondAdapter({this.isUtc = false});

  final bool isUtc;

  @override
  DateTime fromSharedPrefs(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: isUtc);
  }

  @override
  int toSharedPrefs(DateTime value) => value.millisecondsSinceEpoch;
}

/// {@template date_time_string_adapter}
/// Implementation for a DateTime to String converter that uses the ISO8601
/// string representation as the value stored in the shared preferences.
/// {@endtemplate}
class DateTimeStringAdapter extends TypeAdapter<DateTime, String> {
  /// {@macro date_time_string_adapter}
  const DateTimeStringAdapter();

  @override
  DateTime fromSharedPrefs(String value) {
    return DateTime.parse(value);
  }

  @override
  String toSharedPrefs(DateTime value) => value.toIso8601String();
}
