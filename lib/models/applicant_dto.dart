import 'package:json_annotation/json_annotation.dart';

part 'applicant_dto.g.dart';

@JsonSerializable()
class ApplicantDTO {
  int? id;
  String? cifId;
  String? cifSubType;
  String? title;
  String? applicantType;
  String? firstName;
  String? middleName;
  String? lastName;
  DateTime? dob;
  String? gender;
  String? mobile;
  String? manufacturer;
  String? model;
  String? nationality;
  DateTime? kycDate;
  String? kycDoneStatus;
  String? applicantId;
  String? custStatus;
  double? loanAmount;
  DateTime? createdDate;
  ApplicantDeclarationStatus? declaration;


  ApplicantDTO({
    this.id,
    this.cifId,
    this.cifSubType,
    this.title,
    this.applicantType,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dob,
    this.gender,
    this.mobile,
    this.manufacturer,
    this.model,
    this.nationality,
    this.kycDate,
    this.kycDoneStatus,
    this.applicantId,
    this.custStatus,
    this.loanAmount,
    this.declaration,
    this.createdDate,
  });

  factory ApplicantDTO.fromJson(Map<String, dynamic> json) => _$ApplicantDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicantDTOToJson(this);
}

enum ApplicantDeclarationStatus {
  PENDING,
  INITIATED,
  COMPLETED,
  APPROVED,
  REJECTED,
}