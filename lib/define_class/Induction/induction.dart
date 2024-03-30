import 'package:json_annotation/json_annotation.dart';
import 'inductionobj.dart';

part 'induction.g.dart';

@JsonSerializable(explicitToJson: true)
class Induction {
  
  @JsonKey(name: '_id')
  double id;
  String name;
  String typeDevice;
  
  InductionObj status;

  
  Induction(this.id,this.name,this.typeDevice,this.status);


 
  factory Induction.fromJson(Map<String,dynamic> json)
   => _$InductionFromJson(json);

   Map<String,dynamic> toJson() => _$InductionToJson(this);
  
}