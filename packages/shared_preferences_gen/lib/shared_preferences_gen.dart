import 'package:build/build.dart';
import 'package:shared_preferences_gen/src/shared_preferences_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Supports `package:build_runner` creation and configuration of
/// `shared_preferences_gen`.
///
/// Not meant to be invoked by hand-authored code.
Builder sharedPreferencesGen(BuilderOptions options) {
  return SharedPartBuilder(
    const <Generator>[SharedPreferencesGenerator()],
    'shared_preferences_gen',
  );
}
