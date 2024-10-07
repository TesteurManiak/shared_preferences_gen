// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MyModel _$MyModelFromJson(Map<String, dynamic> json) {
  return _MyModel.fromJson(json);
}

/// @nodoc
mixin _$MyModel {
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;

  /// Serializes this MyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyModelCopyWith<MyModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyModelCopyWith<$Res> {
  factory $MyModelCopyWith(MyModel value, $Res Function(MyModel) then) =
      _$MyModelCopyWithImpl<$Res, MyModel>;
  @useResult
  $Res call({String name, int age});
}

/// @nodoc
class _$MyModelCopyWithImpl<$Res, $Val extends MyModel>
    implements $MyModelCopyWith<$Res> {
  _$MyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyModelImplCopyWith<$Res> implements $MyModelCopyWith<$Res> {
  factory _$$MyModelImplCopyWith(
          _$MyModelImpl value, $Res Function(_$MyModelImpl) then) =
      __$$MyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int age});
}

/// @nodoc
class __$$MyModelImplCopyWithImpl<$Res>
    extends _$MyModelCopyWithImpl<$Res, _$MyModelImpl>
    implements _$$MyModelImplCopyWith<$Res> {
  __$$MyModelImplCopyWithImpl(
      _$MyModelImpl _value, $Res Function(_$MyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? age = null,
  }) {
    return _then(_$MyModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MyModelImpl implements _MyModel {
  const _$MyModelImpl({required this.name, required this.age});

  factory _$MyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyModelImplFromJson(json);

  @override
  final String name;
  @override
  final int age;

  @override
  String toString() {
    return 'MyModel(name: $name, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, age);

  /// Create a copy of MyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyModelImplCopyWith<_$MyModelImpl> get copyWith =>
      __$$MyModelImplCopyWithImpl<_$MyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyModelImplToJson(
      this,
    );
  }
}

abstract class _MyModel implements MyModel {
  const factory _MyModel({required final String name, required final int age}) =
      _$MyModelImpl;

  factory _MyModel.fromJson(Map<String, dynamic> json) = _$MyModelImpl.fromJson;

  @override
  String get name;
  @override
  int get age;

  /// Create a copy of MyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyModelImplCopyWith<_$MyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
