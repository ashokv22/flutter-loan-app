// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_code_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceCodeDTO _$ReferenceCodeDTOFromJson(Map<String, dynamic> json) =>
    ReferenceCodeDTO(
      id: json['id'] as String,
      version: (json['version'] as num).toInt(),
      classifier: json['classifier'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      parentClassifier: json['parentClassifier'] as String?,
      parentReferenceCode: json['parentReferenceCode'] as String?,
    );

Map<String, dynamic> _$ReferenceCodeDTOToJson(ReferenceCodeDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'classifier': instance.classifier,
      'name': instance.name,
      'code': instance.code,
      'parentClassifier': instance.parentClassifier,
      'parentReferenceCode': instance.parentReferenceCode,
    };
