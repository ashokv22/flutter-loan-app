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
  double? loanAmount;
  String firstName;
  String? middleName;
  String lastName;
  String? fathersFirstName;
  String? fathersMiddleName;
  String? fathersLastName;
  DateTime dateOfBirth;
  String gender;
  String? maritalStatus;
  String mobileNumber;
  String? alternateMobileNumber;
  String addressLine1;
  String? addressLine2;
  String pinCode;
  String landMark;
  String city;
  String taluka;
  String district;
  String state;
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
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.fathersFirstName,
    this.fathersMiddleName,
    this.fathersLastName,
    required this.dateOfBirth,
    required this.gender,
    this.maritalStatus,
    required this.mobileNumber,
    this.alternateMobileNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.pinCode,
    required this.landMark,
    required this.taluka,
    required this.district,
    required this.city,
    required this.state,
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