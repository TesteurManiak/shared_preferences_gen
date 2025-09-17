// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyModel _$MyModelFromJson(Map<String, dynamic> json) =>
    _MyModel(name: json['name'] as String, age: (json['age'] as num).toInt());

Map<String, dynamic> _$MyModelToJson(_MyModel instance) => <String, dynamic>{
  'name': instance.name,
  'age': instance.age,
};
