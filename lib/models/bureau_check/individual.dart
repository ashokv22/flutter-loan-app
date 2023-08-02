import 'package:json_annotation/json_annotation.dart';
import 'package:origination/models/applicant_dto.dart';

part 'individual.g.dart';

@JsonSerializable()
class Individual {
  int? id;
  IndividualType? type;
  String? product;
  String? enquiryPurpose;
  int? internalRefNumber;
  int? loanAmount;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fathersFirstName;
  String? fathersMiddleName;
  String? fathersLastName;
  DateTime? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? address1;
  String? address2;
  String? pinCode;
  String? landMark;
  String? city;
  String? state;
  String? pan;
  String? voterIdNumber;
  ApplicantDeclarationStatus? status;
  int? applicantId;
  String? approvedBy;
  DateTime? appovedDate;
  String? approvedRemarks;
  String? rejectedBy;
  DateTime? rejectedDate;
  String? rejectedRemarks;

  Individual({
    this.id,
    this.type,
    this.product,
    this.enquiryPurpose,
    this.internalRefNumber,
    this.loanAmount,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fathersFirstName,
    this.fathersMiddleName,
    this.fathersLastName,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.mobileNumber,
    this.alternateMobileNumber,
    this.address1,
    this.address2,
    this.pinCode,
    this.landMark,
    this.city,
    this.state,
    this.pan,
    this.voterIdNumber,
    this.status,
    this.applicantId,
    this.approvedBy,
    this.appovedDate,
    this.approvedRemarks,
    this.rejectedBy,
    this.rejectedDate,
    this.rejectedRemarks
  });

  
  factory Individual.fromJson(Map<String, dynamic> json) => _$IndividualFromJson(json);

  Map<String, dynamic> toJson() => _$IndividualToJson(this);

}

enum IndividualType {
  APPLICANT,
  CO_APPLICANT,
  GUARANTOR
}