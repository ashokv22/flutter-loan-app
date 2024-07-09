// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pan _$PanFromJson(Map<String, dynamic> json) => Pan(
      relatedPartyId: (json['relatedPartyId'] as num).toInt(),
      panNumber: json['panNumber'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$PanToJson(Pan instance) => <String, dynamic>{
      'relatedPartyId': instance.relatedPartyId,
      'panNumber': instance.panNumber,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dateOfBirth': instance.dateOfBirth,
      'isVerified': instance.isVerified,
    };
