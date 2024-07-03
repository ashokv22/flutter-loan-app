// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dedupe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DedupeDTO _$DedupeDTOFromJson(Map<String, dynamic> json) => DedupeDTO(
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      fathersFirstName: json['fathersFirstName'] as String,
      fathersMiddleName: json['fathersMiddleName'] as String?,
      fathersLastName: json['fathersLastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      maritalStatus: json['maritalStatus'] as String,
      emailId: json['emailId'] as String,
      mobileNumber: json['mobileNumber'] as String,
      pinCode: json['pinCode'] as String,
      aadhaarCardNumber: json['aadhaarCardNumber'] as String,
      pan: json['pan'] as String?,
      voterIdNumber: json['voterIdNumber'] as String?,
      passport: json['passport'] as String?,
      drivingLicense: json['drivingLicense'] as String?,
    );

Map<String, dynamic> _$DedupeDTOToJson(DedupeDTO instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'fathersFirstName': instance.fathersFirstName,
      'fathersMiddleName': instance.fathersMiddleName,
      'fathersLastName': instance.fathersLastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'maritalStatus': instance.maritalStatus,
      'emailId': instance.emailId,
      'mobileNumber': instance.mobileNumber,
      'pinCode': instance.pinCode,
      'aadhaarCardNumber': instance.aadhaarCardNumber,
      'pan': instance.pan,
      'voterIdNumber': instance.voterIdNumber,
      'passport': instance.passport,
      'drivingLicense': instance.drivingLicense,
    };
