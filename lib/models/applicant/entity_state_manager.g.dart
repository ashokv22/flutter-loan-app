// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_state_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityStateManager _$EntityStateManagerFromJson(Map<String, dynamic> json) =>
    EntityStateManager(
      id: (json['id'] as num).toInt(),
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String,
      applicationReferenceNum: json['applicationReferenceNum'] as String,
      stateCode: json['stateCode'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String,
      errorData: json['errorData'] as String?,
      field: json['field'] as String?,
      dataError: json['dataError'] as String?,
      actionRequired: json['actionRequired'] as String?,
      reasonForRejection: json['reasonForRejection'] as String?,
      documentRejectionReason: json['documentRejectionReason'] as String?,
      reviewerRemarks: json['reviewerRemarks'] as String?,
      esignData: json['esignData'] as String?,
    );

Map<String, dynamic> _$EntityStateManagerToJson(EntityStateManager instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'applicationReferenceNum': instance.applicationReferenceNum,
      'stateCode': instance.stateCode,
      'description': instance.description,
      'status': instance.status,
      'errorData': instance.errorData,
      'field': instance.field,
      'dataError': instance.dataError,
      'actionRequired': instance.actionRequired,
      'reasonForRejection': instance.reasonForRejection,
      'documentRejectionReason': instance.documentRejectionReason,
      'reviewerRemarks': instance.reviewerRemarks,
      'esignData': instance.esignData,
    };
