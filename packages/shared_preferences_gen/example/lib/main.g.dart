// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SharedPreferencesGenerator
// **************************************************************************

extension $SharedPreferencesGenX on SharedPreferences {
  SharedPrefValue<String> get title {
    final adapter = SharedPrefData.getAdapter<String, String>();
    return SharedPrefValue<String>(
      key: 'title',
      getter: (key) => adapter.fromSharedPrefs(getString(key)),
      setter: (key, value) => setString(key, adapter.toSharedPrefs(value)),
      remover: remove,
    );
  }

  SharedPrefValue<bool> get darkMode {
    final adapter = SharedPrefData.getAdapter<bool, bool>();
    return SharedPrefValue<bool>(
      key: 'darkMode',
      getter: (key) => adapter.fromSharedPrefs(getBool(key)),
      setter: (key, value) => setBool(key, adapter.toSharedPrefs(value)),
      remover: remove,
      defaultValue: false,
    );
  }

  SharedPrefValue<int> get numberOfVisits {
    final adapter = SharedPrefData.getAdapter<int, int>();
    return SharedPrefValue<int>(
      key: 'numberOfVisits',
      getter: (key) => adapter.fromSharedPrefs(getInt(key)),
      setter: (key, value) => setInt(key, adapter.toSharedPrefs(value)),
      remover: remove,
      defaultValue: 0,
    );
  }

  SharedPrefValue<List<String>> get history {
    final adapter = SharedPrefData.getAdapter<List<String>, List<String>>();
    return SharedPrefValue<List<String>>(
      key: 'history',
      getter: (key) => adapter.fromSharedPrefs(getStringList(key)),
      setter: (key, value) => setStringList(key, adapter.toSharedPrefs(value)),
      remover: remove,
      defaultValue: [],
    );
  }

  SharedPrefValue<DateTime> get lastVisit {
    final adapter = SharedPrefData.getAdapter<DateTime, int>();
    return SharedPrefValue<DateTime>(
      key: 'lastVisit',
      getter: (key) => adapter.fromSharedPrefs(getInt(key)),
      setter: (key, value) => setInt(key, adapter.toSharedPrefs(value)),
      remover: remove,
    );
  }
}
