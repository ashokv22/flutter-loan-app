// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namevalue_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NameValueDTO _$NameValueDTOFromJson(Map<String, dynamic> json) => NameValueDTO(
      id: (json['id'] as num?)?.toInt(),
      classifier: json['classifier'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$NameValueDTOToJson(NameValueDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classifier': instance.classifier,
      'name': instance.name,
      'code': instance.code,
    };
