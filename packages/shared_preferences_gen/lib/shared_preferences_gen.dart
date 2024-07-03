library shared_preferences_gen;

import 'package:build/build.dart';
import 'package:shared_preferences_gen/src/shared_preferences_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Supports `package:build_runner` creation and configuration of
/// `shared_preferences_gen`.
///
/// Not meant to be invoked by hand-authored code.
Builder sharedPreferencesGen(BuilderOptions options) {
  return PartBuilder(
    const <Generator>[SharedPreferencesGenerator()],
    '.g.dart',
    header: '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file:  type=lint
    ''',
  );
}
