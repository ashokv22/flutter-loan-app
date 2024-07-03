// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_kyc_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimaryKycDTO _$PrimaryKycDTOFromJson(Map<String, dynamic> json) =>
    PrimaryKycDTO(
      id: (json['id'] as num?)?.toInt(),
      relatedPartyId: (json['relatedPartyId'] as num).toInt(),
      aadhaarNumber: json['aadhaarNumber'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      yearOfBirth: json['yearOfBirth'] as String?,
      address: json['address'] as String,
      isVerified: json['isVerified'] as bool,
      photoBase64: json['photoBase64'] as String?,
    );

Map<String, dynamic> _$PrimaryKycDTOToJson(PrimaryKycDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relatedPartyId': instance.relatedPartyId,
      'aadhaarNumber': instance.aadhaarNumber,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dateOfBirth': instance.dateOfBirth,
      'yearOfBirth': instance.yearOfBirth,
      'address': instance.address,
      'isVerified': instance.isVerified,
      'photoBase64': instance.photoBase64,
    };
