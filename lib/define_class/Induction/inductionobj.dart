import 'package:json_annotation/json_annotation.dart';

part 'inductionobj.g.dart';

@JsonSerializable()
class InductionObj {
  int powerLevel;
  bool power;
  bool cooking;
  bool stirfry;
  int timer;

  InductionObj(this.cooking,this.power,this.powerLevel,this.stirfry,this.timer);
  factory InductionObj.fromJson(Map<String,dynamic> json)
    => _$InductionObjFromJson(json);
  
  Map<String,dynamic> toJson() => _$InductionObjToJson(this);
}