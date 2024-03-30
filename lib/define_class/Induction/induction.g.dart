// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'induction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Induction _$InductionFromJson(Map<String, dynamic> json) => Induction(
      (json['_id'] as num).toDouble(),
      json['name'] as String,
      json['typeDevice'] as String,
      InductionObj.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InductionToJson(Induction instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'typeDevice': instance.typeDevice,
      'status': instance.status.toJson(),
    };
