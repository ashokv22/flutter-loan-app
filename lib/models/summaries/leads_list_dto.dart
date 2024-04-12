import 'package:json_annotation/json_annotation.dart';

part 'leads_list_dto.g.dart';

@JsonSerializable()
class LeadsListDTO {
  int id;
  String name;
  String status;
  String? dsaName;
  String model;
  String mobile;
  String applicantId;
  double? loanAmount;
  DateTime createdDate;

  LeadsListDTO({
    required this.id,
    required this.name,
    required this.status,
    this.dsaName,
    required this.model,
    required this.mobile,
    required this.applicantId,
    this.loanAmount,
    required this.createdDate,
  });

  factory LeadsListDTO.fromJson(Map<String, dynamic> json) => _$LeadsListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LeadsListDTOToJson(this);


}