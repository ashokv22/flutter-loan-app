import 'package:json_annotation/json_annotation.dart';

part 'pan_response_dto.g.dart';

@JsonSerializable()
class PanResponseDTO {
  int? id; 
  String panNo;
  String panStatus;
  String name;
  String? fatherName;
  String? dob;
  String? seedingStatus;
  PanResponseDTO({
    this.id,
    required this.panNo,
    required this.panStatus,
    required this.name,
    this.fatherName,
    this.dob,
    this.seedingStatus,
  });

  factory PanResponseDTO.fromJson(Map<String, dynamic> json) => _$PanResponseDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PanResponseDTOToJson(this);

}
