// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socketC.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketC _$SocketCFromJson(Map<String, dynamic> json) => SocketC(
      json['_id'] as int,
      json['name'] as String,
      SocketObj.fromJson(json['status'] as Map<String, dynamic>),
      json['typeDevice'] as String,
    );

Map<String, dynamic> _$SocketCToJson(SocketC instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'typeDevice': instance.typeDevice,
      'status': instance.status.toJson(),
    };
