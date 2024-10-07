// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SharedPreferencesGenerator
// **************************************************************************

extension $SharedPreferencesGenX on SharedPreferences {
  Set<$SharedPrefValueGen> get entries =>
      {title, darkMode, numberOfVisits, history, lastVisit, themeMode, myModel};

  $SharedPrefValueWithDefault<String> get title {
    return $SharedPrefValueWithDefault<String>(
      key: 'title',
      getter: getString,
      setter: setString,
      remover: remove,
      defaultValue: 'Hello, World!',
    );
  }

  $SharedPrefValueWithDefault<bool> get darkMode {
    return $SharedPrefValueWithDefault<bool>(
      key: 'darkMode',
      getter: getBool,
      setter: setBool,
      remover: remove,
      defaultValue: false,
    );
  }

  $SharedPrefValueWithDefault<int> get numberOfVisits {
    return $SharedPrefValueWithDefault<int>(
      key: 'numberOfVisits',
      getter: getInt,
      setter: setInt,
      remover: remove,
      defaultValue: 0,
    );
  }

  $SharedPrefValueWithDefault<List<String>> get history {
    return $SharedPrefValueWithDefault<List<String>>(
      key: 'history',
      getter: getStringList,
      setter: setStringList,
      remover: remove,
      defaultValue: ['0', '1'],
    );
  }

  $SharedPrefValue<DateTime> get lastVisit {
    const adapter = DateTimeMillisecondAdapter();
    return $SharedPrefValue<DateTime>(
      key: 'lastVisit',
      getter: (k) => adapter.fromSharedPrefs(getInt(k)),
      setter: (k, v) => setInt(k, adapter.toSharedPrefs(v)),
      remover: remove,
    );
  }

  $SharedPrefValueWithDefault<ThemeMode> get themeMode {
    const adapter = _$ThemeModeConverterType;
    return $SharedPrefValueWithDefault<ThemeMode>(
      key: 'themeMode',
      getter: (k) => adapter.fromSharedPrefs(getInt(k)),
      setter: (k, v) => setInt(k, adapter.toSharedPrefs(v)),
      remover: remove,
      defaultValue: ThemeMode.system,
    );
  }

  $SharedPrefValueWithDefault<MyModel> get myModel {
    final adapter = SerializableAdapter<MyModel>(
      fromJson: MyModel.fromJson,
      toJson: (v) => v.toJson(),
    );
    return $SharedPrefValueWithDefault<MyModel>(
      key: 'myModel',
      getter: (k) => adapter.fromSharedPrefs(getString(k)),
      setter: (k, v) => setString(k, adapter.toSharedPrefs(v)),
      remover: remove,
      defaultValue: _defaultObj,
    );
  }
}

const _$ThemeModeConverterType = EnumIndexAdapter<ThemeMode>(ThemeMode.values);
