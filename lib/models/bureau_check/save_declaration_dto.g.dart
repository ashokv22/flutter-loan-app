// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_declaration_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveDeclarationDTO _$SaveDeclarationDTOFromJson(Map<String, dynamic> json) =>
    SaveDeclarationDTO(
      id: json['id'] as int?,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as int?,
      modeOfAcceptance: json['modeOfAcceptance'] as String?,
      dateOfAcceptance: json['dateOfAcceptance'] == null
          ? null
          : DateTime.parse(json['dateOfAcceptance'] as String),
      status: json['status'] as String?,
      declarationMasterId: json['declarationMasterId'] as int?,
    );

Map<String, dynamic> _$SaveDeclarationDTOToJson(SaveDeclarationDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'modeOfAcceptance': instance.modeOfAcceptance,
      'dateOfAcceptance': instance.dateOfAcceptance?.toIso8601String(),
      'status': instance.status,
      'declarationMasterId': instance.declarationMasterId,
    };
