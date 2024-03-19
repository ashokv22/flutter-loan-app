// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secondary_kyc_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecondaryKYCDTO _$SecondaryKYCDTOFromJson(Map<String, dynamic> json) =>
    SecondaryKYCDTO(
      id: json['id'] as int,
      relatedPartyId: json['relatedPartyId'] as int,
      panNumber: json['panNumber'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$SecondaryKYCDTOToJson(SecondaryKYCDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relatedPartyId': instance.relatedPartyId,
      'panNumber': instance.panNumber,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'isVerified': instance.isVerified,
    };
