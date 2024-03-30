import 'package:json_annotation/json_annotation.dart';

part 'socketobj.g.dart';

@JsonSerializable()
class SocketObj{
  bool button1;
  bool button2;
  // bool both;
  SocketObj(this.button1,this.button2);

  factory SocketObj.fromJson(Map<String, dynamic> json) =>
      _$SocketObjFromJson(json);
  Map<String, dynamic> toJson() => _$SocketObjToJson(this);
}