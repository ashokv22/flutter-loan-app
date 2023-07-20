// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicantDTO _$ApplicantDTOFromJson(Map<String, dynamic> json) => ApplicantDTO(
      id: json['id'] as int?,
      cifId: json['cifId'] as String?,
      cifSubType: json['cifSubType'] as String?,
      title: json['title'] as String?,
      applicantType: json['applicantType'] as String?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      gender: json['gender'] as String?,
      nationality: json['nationality'] as String?,
      kycDate: json['kycDate'] == null
          ? null
          : DateTime.parse(json['kycDate'] as String),
      kycDoneStatus: json['kycDoneStatus'] as String?,
      applicantId: json['applicantId'] as String?,
      custStatus: json['custStatus'] as String?,
      loanAmount: (json['loanAmount'] as num?)?.toDouble(),
      declaration: $enumDecodeNullable(
          _$ApplicantDeclarationStatusEnumMap, json['declaration']),
    );

Map<String, dynamic> _$ApplicantDTOToJson(ApplicantDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cifId': instance.cifId,
      'cifSubType': instance.cifSubType,
      'title': instance.title,
      'applicantType': instance.applicantType,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'dob': instance.dob?.toIso8601String(),
      'gender': instance.gender,
      'nationality': instance.nationality,
      'kycDate': instance.kycDate?.toIso8601String(),
      'kycDoneStatus': instance.kycDoneStatus,
      'applicantId': instance.applicantId,
      'custStatus': instance.custStatus,
      'loanAmount': instance.loanAmount,
      'declaration': _$ApplicantDeclarationStatusEnumMap[instance.declaration],
    };

const _$ApplicantDeclarationStatusEnumMap = {
  ApplicantDeclarationStatus.PENDING: 'PENDING',
  ApplicantDeclarationStatus.INITIATED: 'INITIATED',
  ApplicantDeclarationStatus.COMPLETED: 'COMPLETED',
};
