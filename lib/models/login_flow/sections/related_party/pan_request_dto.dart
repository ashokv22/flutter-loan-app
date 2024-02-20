
import 'package:json_annotation/json_annotation.dart';

part 'pan_request_dto.g.dart';

@JsonSerializable()
class PanRequestDTO {
  String? id;
  String panNo;
  String exist;
  String? title;
  String issueDate;
  String firstname;
  String? middlename;
  String lastname;
  PanRequestDTO({
    this.id,
    required this.panNo,
    required this.exist,
    this.title,
    required this.issueDate,
    required this.firstname,
    this.middlename,
    required this.lastname,
  });

  factory PanRequestDTO.fromJson(Map<String, dynamic> json) => _$PanRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PanRequestDTOToJson(this);
}
