// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'pan_request_dto.g.dart';

@JsonSerializable()
class PanRequestDTO {
  String? id;
  String panNo;
  String panStatus;
  String name;
  String? fatherName;
  String? dob;
  String? seedingData;
  PanRequestDTO({
    this.id,
    required this.panNo,
    required this.panStatus,
    required this.name,
    this.fatherName,
    this.dob,
    this.seedingData,
  });
  factory PanRequestDTO.fromJson(Map<String, dynamic> json) => _$PanRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PanRequestDTOToJson(this);
}
