import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

Iterable<FieldElement>? iterateEnumFields(DartType targetType) {
  if (targetType is InterfaceType && targetType.element is EnumElement) {
    return targetType.element.fields.where((e) => e.isEnumConstant);
  }
  return null;
}

String jsonLiteralAsDart(Object? value) {
  if (value == null) return 'null';

  if (value is String) return escapeDartString(value);
  if (value is double) {
    if (value.isNaN) return 'double.nan';
    if (value.isInfinite) {
      if (value.isNegative) return 'double.negativeInfinity';
      return 'double.infinity';
    }
  }
  if (value is bool || value is num) return value.toString();

  if (value is List) {
    final listItems = value.map(jsonLiteralAsDart).join(', ');
    return '[$listItems]';
  }
  if (value is Set) {
    final setItems = value.map(jsonLiteralAsDart).join(', ');
    return '{$setItems}';
  }
  if (value is Map) return jsonMapAsDart(value);

  throw StateError(
    'Should never get here - with ${value.runtimeType} - `$value`',
  );
}

String jsonMapAsDart(Map map) {
  final buffer = StringBuffer('{');
  bool first = true;
  for (final MapEntry(:key, :value) in map.entries) {
    if (first) {
      first = false;
    } else {
      buffer.writeln(',');
    }
    buffer
      ..write(escapeDartString(key as String))
      ..write(': ')
      ..write(jsonLiteralAsDart(value));
  }
  buffer.write('}');
  return buffer.toString();
}
