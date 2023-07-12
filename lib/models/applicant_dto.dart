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
  String? nationality;
  DateTime? kycDate;
  String? kycDoneStatus;
  String? applicantId;
  String? custStatus;
  double? loanAmount;

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
    this.nationality,
    this.kycDate,
    this.kycDoneStatus,
    this.applicantId,
    this.custStatus,
    this.loanAmount,
  });

  factory ApplicantDTO.fromJson(Map<String, dynamic> json) => _$ApplicantDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicantDTOToJson(this);

  // factory ApplicantDTO.fromJson(Map<String, dynamic> json) {
  //   return ApplicantDTO(
  //     id: json['id'],
  //     cifId: json['cifId'],
  //     cifSubType: json['cifSubType'],
  //     title: json['title'],
  //     applicantType: json['applicantType'],
  //     firstName: json['firstName'],
  //     middleName: json['middleName'],
  //     lastName: json['lastName'],
  //     dob: DateTime.parse(json['dob']),
  //     gender: json['gender'],
  //     nationality: json['nationality'],
  //     kycDate: DateTime.parse(json['kycDate']),
  //     kycDoneStatus: json['kycDoneStatus'],
  //     applicantId: json['applicantId'],
  //     custStatus: json['custStatus'],
  //     loanAmount: json['loanAmount'].toDouble(),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'cifId': cifId,
  //     'cifSubType': cifSubType,
  //     'title': title,
  //     'applicantType': applicantType,
  //     'firstName': firstName,
  //     'middleName': middleName,
  //     'lastName': lastName,
  //     'dob': dob!.toIso8601String(),
  //     'gender': gender,
  //     'nationality': nationality,
  //     'kycDate': kycDate!.toIso8601String(),
  //     'kycDoneStatus': kycDoneStatus,
  //     'applicantId': applicantId,
  //     'custStatus': custStatus,
  //     'loanAmount': loanAmount,
  //   };
  // }
}
