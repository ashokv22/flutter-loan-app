// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanRequestDTO _$PanRequestDTOFromJson(Map<String, dynamic> json) =>
    PanRequestDTO(
      id: json['id'] as String?,
      panNo: json['panNo'] as String,
      panStatus: json['panStatus'] as String,
      name: json['name'] as String,
      fatherName: json['fatherName'] as String?,
      dob: json['dob'] as String?,
      seedingData: json['seedingData'] as String?,
    );

Map<String, dynamic> _$PanRequestDTOToJson(PanRequestDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'panNo': instance.panNo,
      'panStatus': instance.panStatus,
      'name': instance.name,
      'fatherName': instance.fatherName,
      'dob': instance.dob,
      'seedingData': instance.seedingData,
    };
