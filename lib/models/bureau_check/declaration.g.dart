// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'declaration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeclarationMasterDTO _$DeclarationMasterDTOFromJson(
        Map<String, dynamic> json) =>
    DeclarationMasterDTO(
      id: json['id'] as int,
      entityType: json['entityType'] as String,
      declarationContent: json['declarationContent'] as String,
      fromDate: DateTime.parse(json['fromDate'] as String),
      toDate: DateTime.parse(json['toDate'] as String),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$DeclarationMasterDTOToJson(
        DeclarationMasterDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'declarationContent': instance.declarationContent,
      'fromDate': instance.fromDate.toIso8601String(),
      'toDate': instance.toDate.toIso8601String(),
      'isActive': instance.isActive,
    };
