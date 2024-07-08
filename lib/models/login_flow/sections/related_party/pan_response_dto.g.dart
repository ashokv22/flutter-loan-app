// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanResponseDTO _$PanResponseDTOFromJson(Map<String, dynamic> json) =>
    PanResponseDTO(
      id: json['id'] as int?,
      panNo: json['panNo'] as String,
      panStatus: json['panStatus'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String?,
      dob: json['dob'] as String?,
      seedingStatus: json['seedingStatus'] as String?,
    );

Map<String, dynamic> _$PanResponseDTOToJson(PanResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'panNo': instance.panNo,
      'panStatus': instance.panStatus,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dob': instance.dob,
      'seedingStatus': instance.seedingStatus,
    };
