// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Individual _$IndividualFromJson(Map<String, dynamic> json) => Individual(
      id: json['id'] as int?,
      type: $enumDecodeNullable(_$IndividualTypeEnumMap, json['type']),
      product: json['product'] as String?,
      enquiryPurpose: json['enquiryPurpose'] as String?,
      internalRefNumber: json['internalRefNumber'] as int?,
      loanAmount: json['loanAmount'] as int?,
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      fathersFirstName: json['fathersFirstName'] as String?,
      fathersMiddleName: json['fathersMiddleName'] as String?,
      fathersLastName: json['fathersLastName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      alternateMobileNumber: json['alternateMobileNumber'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      pinCode: json['pinCode'] as String?,
      landMark: json['landMark'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pan: json['pan'] as String?,
      voterIdNumber: json['voterIdNumber'] as String?,
      status: $enumDecodeNullable(
          _$ApplicantDeclarationStatusEnumMap, json['status']),
      applicantId: json['applicantId'] as int?,
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
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'maritalStatus': instance.maritalStatus,
      'mobileNumber': instance.mobileNumber,
      'alternateMobileNumber': instance.alternateMobileNumber,
      'address1': instance.address1,
      'address2': instance.address2,
      'pinCode': instance.pinCode,
      'landMark': instance.landMark,
      'city': instance.city,
      'state': instance.state,
      'pan': instance.pan,
      'voterIdNumber': instance.voterIdNumber,
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
  ApplicantDeclarationStatus.REJECTED: 'REJECTED',
};