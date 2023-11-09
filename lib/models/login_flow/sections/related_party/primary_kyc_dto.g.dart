// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_kyc_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrimaryKycDTO _$PrimaryKycDTOFromJson(Map<String, dynamic> json) =>
    PrimaryKycDTO(
      id: json['id'] as int?,
      relatedPartyId: json['relatedPartyId'] as int,
      adharNumber: json['adharNumber'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      address: json['address'] as String,
    );

Map<String, dynamic> _$PrimaryKycDTOToJson(PrimaryKycDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relatedPartyId': instance.relatedPartyId,
      'adharNumber': instance.adharNumber,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'address': instance.address,
    };
