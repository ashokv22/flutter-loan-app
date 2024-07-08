// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_code_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceCodeDTO _$ReferenceCodeDTOFromJson(Map<String, dynamic> json) =>
    ReferenceCodeDTO(
      id: json['id'] as String,
      version: json['version'] as int,
      classifier: json['classifier'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      parentClassifier: json['parentClassifier'] as String?,
      parentReferenceCode: json['parentReferenceCode'] as String?,
      status: json['status'] as int,
      field1: json['field1'] as String?,
      field2: json['field2'] as String?,
      field3: json['field3'] as String?,
      field4: json['field4'] as String?,
      field5: json['field5'] as String?,
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
      'status': instance.status,
      'field1': instance.field1,
      'field2': instance.field2,
      'field3': instance.field3,
      'field4': instance.field4,
      'field5': instance.field5,
    };
