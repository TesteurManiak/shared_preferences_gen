// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyModel {

 String get name; int get age;
/// Create a copy of MyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyModelCopyWith<MyModel> get copyWith => _$MyModelCopyWithImpl<MyModel>(this as MyModel, _$identity);

  /// Serializes this MyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyModel&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,age);

@override
String toString() {
  return 'MyModel(name: $name, age: $age)';
}


}

/// @nodoc
abstract mixin class $MyModelCopyWith<$Res>  {
  factory $MyModelCopyWith(MyModel value, $Res Function(MyModel) _then) = _$MyModelCopyWithImpl;
@useResult
$Res call({
 String name, int age
});




}
/// @nodoc
class _$MyModelCopyWithImpl<$Res>
    implements $MyModelCopyWith<$Res> {
  _$MyModelCopyWithImpl(this._self, this._then);

  final MyModel _self;
  final $Res Function(MyModel) _then;

/// Create a copy of MyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? age = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyModel].
extension MyModelPatterns on MyModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyModel value)  $default,){
final _that = this;
switch (_that) {
case _MyModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyModel value)?  $default,){
final _that = this;
switch (_that) {
case _MyModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int age)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyModel() when $default != null:
return $default(_that.name,_that.age);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int age)  $default,) {final _that = this;
switch (_that) {
case _MyModel():
return $default(_that.name,_that.age);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int age)?  $default,) {final _that = this;
switch (_that) {
case _MyModel() when $default != null:
return $default(_that.name,_that.age);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyModel implements MyModel {
  const _MyModel({required this.name, required this.age});
  factory _MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);

@override final  String name;
@override final  int age;

/// Create a copy of MyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyModelCopyWith<_MyModel> get copyWith => __$MyModelCopyWithImpl<_MyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyModel&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,age);

@override
String toString() {
  return 'MyModel(name: $name, age: $age)';
}


}

/// @nodoc
abstract mixin class _$MyModelCopyWith<$Res> implements $MyModelCopyWith<$Res> {
  factory _$MyModelCopyWith(_MyModel value, $Res Function(_MyModel) _then) = __$MyModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int age
});




}
/// @nodoc
class __$MyModelCopyWithImpl<$Res>
    implements _$MyModelCopyWith<$Res> {
  __$MyModelCopyWithImpl(this._self, this._then);

  final _MyModel _self;
  final $Res Function(_MyModel) _then;

/// Create a copy of MyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? age = null,}) {
  return _then(_MyModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
