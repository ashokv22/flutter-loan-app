// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Individual _$IndividualFromJson(Map<String, dynamic> json) => Individual(
      id: (json['id'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$IndividualTypeEnumMap, json['type']),
      product: json['product'] as String?,
      enquiryPurpose: json['enquiryPurpose'] as String?,
      internalRefNumber: (json['internalRefNumber'] as num?)?.toInt(),
      loanAmount: (json['loanAmount'] as num?)?.toDouble(),
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      fathersFirstName: json['fathersFirstName'] as String?,
      fathersMiddleName: json['fathersMiddleName'] as String?,
      fathersLastName: json['fathersLastName'] as String?,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      maritalStatus: json['maritalStatus'] as String?,
      mobileNumber: json['mobileNumber'] as String,
      alternateMobileNumber: json['alternateMobileNumber'] as String?,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      pinCode: json['pinCode'] as String,
      landMark: json['landMark'] as String,
      taluka: json['taluka'] as String,
      district: json['district'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      pan: json['pan'] as String?,
      voterIdNumber: json['voterIdNumber'] as String?,
      commentsByRm: json['commentsByRm'] as String?,
      status: $enumDecodeNullable(
          _$ApplicantDeclarationStatusEnumMap, json['status']),
      applicantId: (json['applicantId'] as num?)?.toInt(),
      approvedBy: json['approvedBy'] as String?,
      appovedDate: json['appovedDate'] == null
          ? null
          : DateTime.parse(json['appovedDate'] as String),
      approvedRemarks: json['approvedRemarks'] as String?,
      rejectedBy: json['rejectedBy'] as String?,
      rejectedDate: json['rejectedDate'] == null
          ? null
          : DateTime.parse(json['rejectedDate'] as String),
      rejectedRemarks: json['rejectedRemarks'] as String?,
    );

Map<String, dynamic> _$IndividualToJson(Individual instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$IndividualTypeEnumMap[instance.type],
      'product': instance.product,
      'enquiryPurpose': instance.enquiryPurpose,
      'internalRefNumber': instance.internalRefNumber,
      'loanAmount': instance.loanAmount,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'fathersFirstName': instance.fathersFirstName,
      'fathersMiddleName': instance.fathersMiddleName,
      'fathersLastName': instance.fathersLastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'maritalStatus': instance.maritalStatus,
      'mobileNumber': instance.mobileNumber,
      'alternateMobileNumber': instance.alternateMobileNumber,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'pinCode': instance.pinCode,
      'landMark': instance.landMark,
      'city': instance.city,
      'taluka': instance.taluka,
      'district': instance.district,
      'state': instance.state,
      'country': instance.country,
      'pan': instance.pan,
      'voterIdNumber': instance.voterIdNumber,
      'commentsByRm': instance.commentsByRm,
      'status': _$ApplicantDeclarationStatusEnumMap[instance.status],
      'applicantId': instance.applicantId,
      'approvedBy': instance.approvedBy,
      'appovedDate': instance.appovedDate?.toIso8601String(),
      'approvedRemarks': instance.approvedRemarks,
      'rejectedBy': instance.rejectedBy,
      'rejectedDate': instance.rejectedDate?.toIso8601String(),
      'rejectedRemarks': instance.rejectedRemarks,
    };

const _$IndividualTypeEnumMap = {
  IndividualType.APPLICANT: 'APPLICANT',
  IndividualType.CO_APPLICANT: 'CO_APPLICANT',
  IndividualType.GUARANTOR: 'GUARANTOR',
};

const _$ApplicantDeclarationStatusEnumMap = {
  ApplicantDeclarationStatus.PENDING: 'PENDING',
  ApplicantDeclarationStatus.INITIATED: 'INITIATED',
  ApplicantDeclarationStatus.COMPLETED: 'COMPLETED',
  ApplicantDeclarationStatus.APPROVED: 'APPROVED',
  ApplicantDeclarationStatus.REJECTED: 'REJECTED',
};
