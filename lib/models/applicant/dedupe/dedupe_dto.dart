import 'package:json_annotation/json_annotation.dart';

part 'dedupe_dto.g.dart';

@JsonSerializable()
class DedupeDTO {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String fathersFirstName;
  final String? fathersMiddleName;
  final String fathersLastName;
  final DateTime dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String emailId;
  final String mobileNumber;
  final String pinCode;
  final String aadhaarCardNumber;
  final String? pan;
  final String? voterIdNumber;
  final String? passport;
  final String? drivingLicense;

  DedupeDTO({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.fathersFirstName,
    this.fathersMiddleName,
    required this.fathersLastName,
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.emailId,
    required this.mobileNumber,
    required this.pinCode,
    required this.aadhaarCardNumber,
    this.pan,
    this.voterIdNumber,
    this.passport,
    this.drivingLicense,
  });

  factory DedupeDTO.fromJson(Map<String, dynamic> json) => _$DedupeDTOFromJson(json);
  Map<String, dynamic> toJson() => _$DedupeDTOToJson(this);

}
