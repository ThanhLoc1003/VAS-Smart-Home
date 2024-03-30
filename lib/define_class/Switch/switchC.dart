import 'package:json_annotation/json_annotation.dart';

import 'switchobj.dart';

part 'switchC.g.dart';

@JsonSerializable(explicitToJson:  true)
class SwitchC{
  
  @JsonKey(name: '_id')
  int id;
  String name;
  String typeDevice;
  SwitchObj status;
  // String room;
  
  // @JsonKey(name: '__v')
  // int v;
  SwitchC(this.id,this.name,this.status,this.typeDevice);
  
  factory SwitchC.fromJson(Map<String,dynamic> json)
   => _$SwitchCFromJson(json);

   Map<String,dynamic> toJson() => _$SwitchCToJson(this);

}