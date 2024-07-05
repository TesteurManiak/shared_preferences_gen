// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// SharedPreferencesGenerator
// **************************************************************************

extension $SharedPreferencesGenX on SharedPreferences {
  SharedPrefValue<String> get title => SharedPrefValue<String>(
        key: 'title',
        getter: getString,
        setter: setString,
        remover: remove,
      );

  SharedPrefValue<bool> get darkMode => SharedPrefValue<bool>(
        key: 'darkMode',
        getter: getBool,
        setter: setBool,
        remover: remove,
        defaultValue: false,
      );

  SharedPrefValue<int> get numberOfVisits => SharedPrefValue<int>(
        key: 'numberOfVisits',
        getter: getInt,
        setter: setInt,
        remover: remove,
        defaultValue: 0,
      );

  SharedPrefValue<List<String>> get history => SharedPrefValue<List<String>>(
        key: 'history',
        getter: getStringList,
        setter: setStringList,
        remover: remove,
        defaultValue: [],
      );
}
