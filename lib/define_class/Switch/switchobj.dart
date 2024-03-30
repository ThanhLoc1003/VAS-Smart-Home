import 'package:json_annotation/json_annotation.dart';

part 'switchobj.g.dart';

@JsonSerializable()
class SwitchObj{
  bool button1;
  bool button2;
  // bool both;
  SwitchObj(this.button1,this.button2);

  factory SwitchObj.fromJson(Map<String, dynamic> json) =>
      _$SwitchObjFromJson(json);
  Map<String, dynamic> toJson() => _$SwitchObjToJson(this);
}