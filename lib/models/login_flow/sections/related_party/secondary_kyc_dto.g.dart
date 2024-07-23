// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secondary_kyc_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecondaryKYCDTO _$SecondaryKYCDTOFromJson(Map<String, dynamic> json) =>
    SecondaryKYCDTO(
      id: (json['id'] as num?)?.toInt(),
      relatedPartyId: (json['relatedPartyId'] as num).toInt(),
      kycType: json['kycType'] as String,
      panNumber: json['panNumber'] as String?,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      isVerified: json['isVerified'] as bool,
      form60Id: (json['form60Id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SecondaryKYCDTOToJson(SecondaryKYCDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relatedPartyId': instance.relatedPartyId,
      'kycType': instance.kycType,
      'panNumber': instance.panNumber,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'isVerified': instance.isVerified,
      'form60Id': instance.form60Id,
    };
