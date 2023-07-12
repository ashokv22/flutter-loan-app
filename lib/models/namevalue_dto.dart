import 'package:json_annotation/json_annotation.dart';

part 'namevalue_dto.g.dart';

@JsonSerializable()
class NameValueDTO {
  int? id;
  String? classifier;
  String? name;
  String? code;
  

  NameValueDTO({
    this.id,
    this.classifier,
    this.name,
    this.code,
  });

  factory NameValueDTO.fromJson(Map<String, dynamic> json) => _$NameValueDTOFromJson(json);
  Map<String, dynamic> toJson() => _$NameValueDTOToJson(this);

}