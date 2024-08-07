# shared_preferences_gen

[![Pub Version (including pre-releases)](https://img.shields.io/pub/v/shared_preferences_gen?include_prereleases)][pub-package]
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg)](https://github.com/invertase/melos)

A code generator that provides strongly-typed accessors for Flutter shared_preferences entries.

## Features

* Check for duplicate keys
* Type-safe accessors for shared preferences
* Support for:
  * `DateTime`
  * `enum`
  * Serializable objects with `fromJson` constructor and `toJson` method

# How to use

## Install

Make sure to add these packages to the project dependencies:

```sh
flutter pub add --dev build_runner
flutter pub add --dev shared_preferences_gen
flutter pub add shared_preferences_annotation
```

## Compatibility with `json_serializable`

If you are using `json_serializable`, you need to add the following configuration to your `build.yaml` file:

```yaml
global_options:
  json_serializable:
    runs_before:
      - shared_preferences_gen
```

This will ensure that the generated `toJson` and `fromJson` methods are available when analyzing the code.

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

To create a shared preferences entry, first create an annotation `@SharedPrefData` in the file where you want to store your instance of `SharedPreferences`. Then add an entry with its corresponding type, key and default value (optional).

### `SharedPrefEntry`

A `SharedPrefEntry` can be used with any of those types:

* `bool`
* `double`
* `int`
* `String`
* `List<String>`
* `DateTime`
* Any `enum`
* Any serializable object with a `toJson` method and `fromJson` factory constructor

```dart
@SharedPrefData(entries: [
  SharedPrefEntry<String>(key: 'myKey'),
])
void main() { /* ... */ }
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

## Roadmap

* Support for custom objects (no ETA)

[pub-package]: https://pub.dev/packages/shared_preferences_gen