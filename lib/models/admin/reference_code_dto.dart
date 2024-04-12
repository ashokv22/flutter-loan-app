import 'package:json_annotation/json_annotation.dart';

part 'reference_code_dto.g.dart';

@JsonSerializable()
class ReferenceCodeDTO {
  String id;
  int version;
  String classifier;
  String name;
  String code;
  String? parentClassifier;
  String? parentReferenceCode;
  // int status;
  // String? field1;
  // String? field2;
  // String? field3;
  // String? field4;
  // String? field5;

  ReferenceCodeDTO({
    required this.id,
    required this.version,
    required this.classifier,
    required this.name,
    required this.code,
    this.parentClassifier,
    this.parentReferenceCode,
    // required this.status,
    // this.field1,
    // this.field2,
    // this.field3,
    // this.field4,
    // this.field5,
  });
  factory ReferenceCodeDTO.fromJson(Map<String, dynamic> json) => _$ReferenceCodeDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceCodeDTOToJson(this);

}
