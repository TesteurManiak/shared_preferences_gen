// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SharedPreferencesGenerator
// **************************************************************************

extension $SharedPreferencesGenX on SharedPreferences {
  SharedPrefValue<String> get title {
    return SharedPrefValue<String>(
      key: 'title',
      getter: getString,
      setter: setString,
      remover: remove,
    );
  }

  SharedPrefValue<bool> get darkMode {
    return SharedPrefValue<bool>(
      key: 'darkMode',
      getter: getBool,
      setter: setBool,
      remover: remove,
      defaultValue: false,
    );
  }

  SharedPrefValue<int> get numberOfVisits {
    return SharedPrefValue<int>(
      key: 'numberOfVisits',
      getter: getInt,
      setter: setInt,
      remover: remove,
      defaultValue: 0,
    );
  }

  SharedPrefValue<List<String>> get history {
    return SharedPrefValue<List<String>>(
      key: 'history',
      getter: getStringList,
      setter: setStringList,
      remover: remove,
      defaultValue: [],
    );
  }

  SharedPrefValue<DateTime> get lastVisit {
    const adapter = DateTimeMillisecondAdapter();
    return SharedPrefValue<DateTime>(
      key: 'lastVisit',
      getter: (k) => adapter.fromSharedPrefs(getInt(k)),
      setter: (k, v) => setInt(k, adapter.toSharedPrefs(v)),
      remover: remove,
    );
  }

  SharedPrefValue<Map<String, dynamic>> get myMap {
    const adapter = MapAdapter();
    return SharedPrefValue<Map<String, dynamic>>(
      key: 'myMap',
      getter: (k) => adapter.fromSharedPrefs(getString(k)),
      setter: (k, v) => setString(k, adapter.toSharedPrefs(v)),
      remover: remove,
      defaultValue: {},
    );
  }
}
