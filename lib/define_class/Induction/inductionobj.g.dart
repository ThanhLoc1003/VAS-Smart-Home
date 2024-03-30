// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inductionobj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InductionObj _$InductionObjFromJson(Map<String, dynamic> json) => InductionObj(
      json['cooking'] as bool,
      json['power'] as bool,
      json['powerLevel'] as int,
      json['stirfry'] as bool,
      json['timer'] as int,
    );

Map<String, dynamic> _$InductionObjToJson(InductionObj instance) =>
    <String, dynamic>{
      'powerLevel': instance.powerLevel,
      'power': instance.power,
      'cooking': instance.cooking,
      'stirfry': instance.stirfry,
      'timer': instance.timer,
    };
