import 'package:json_annotation/json_annotation.dart';

import 'socketobj.dart';

part 'socketC.g.dart';

@JsonSerializable(explicitToJson:  true)
class SocketC{
  
  @JsonKey(name: '_id')
  int id;
  String name;
  String typeDevice;
  SocketObj status;
  // String room;
  
  // @JsonKey(name: '__v')
  // int v;
  SocketC(this.id,this.name,this.status,this.typeDevice);
  
  factory SocketC.fromJson(Map<String,dynamic> json)
   => _$SocketCFromJson(json);

   Map<String,dynamic> toJson() => _$SocketCToJson(this);

}