# shared_preferences_gen

[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg)](https://github.com/invertase/melos)

Typesafe code generation for Flutter shared_preferences.

## Features

* Check for duplicate keys
* Type-safe accessors for shared preferences
* Support for `DateTime` and `Enum` (coming soon)

# How to use

## Install

**This package is not yet published. Use git dependencies if you want to try it.**

```yaml
dependencies
  shared_preferences_annotation:
    git:
      url: https://github.com/TesteurManiak/shared_preferences_gen.git
      ref: main
      path: packages/shared_preferences_annotation

dev_dependencies:
  shared_preferences_gen:
    git:
      url: https://github.com/TesteurManiak/shared_preferences_gen.git
      ref: main
      path: packages/shared_preferences_gen
```

~~Make sure to add these packages to the project dependencies:~~

```sh
flutter pub add --dev build_runner
flutter pub add --dev shared_preferences_gen
flutter pub add shared_preferences_annotation
```

## Add imports and part directive

Make sure to specify the correct file name in a part directive. In the example below, replace "name" with the file name.

```dart
import 'package:shared_preferences_annotation/shared_preferences_annotation.dart';

part 'name.g.dart';
```

## Run the code generator

To run the code generator, run the following commands:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Create a shared preferences entry

To create a shared preferences entry, first create an annotation `@SharedPrefData` in the file where you want to store your instance of `SharedPreferences`. Then add a `SharedPrefEntry` with its corresponding type, key and default value (optional).

```dart
@SharedPrefData([
  SharedPrefEntry<String>(key: 'myKey'),
  SharedPrefEntry<bool>(key: 'darkMode', defaultValue: false),
])
void main() {
    // ...
}
```

## Read an entry

You can access the generated entries directly from your instance of `SharedPreferences`.

```dart
final prefs = await SharedPreferences.getInstance();
String myKey = prefs.myKey.value;
bool darkMode = prefs.darkMode.value;
```

## Write an entry

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.myKey.setValue('newValue');
```

## Remove an entry

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.myKey.remove();
```

## TODO

* Support for `DateTime`
* Support for `Enum`s
* Support for custom types