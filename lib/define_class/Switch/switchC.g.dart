// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switchC.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwitchC _$SwitchCFromJson(Map<String, dynamic> json) => SwitchC(
      json['_id'] as int,
      json['name'] as String,
      SwitchObj.fromJson(json['status'] as Map<String, dynamic>),
      json['typeDevice'] as String,
    );

Map<String, dynamic> _$SwitchCToJson(SwitchC instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'typeDevice': instance.typeDevice,
      'status': instance.status.toJson(),
    };
