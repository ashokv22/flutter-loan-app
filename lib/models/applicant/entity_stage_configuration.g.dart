// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_stage_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityStageConfiguration _$EntityStageConfigurationFromJson(
        Map<String, dynamic> json) =>
    EntityStageConfiguration(
      id: (json['id'] as num).toInt(),
      stage: json['stage'] as String,
      status: json['status'] as String?,
      order: (json['order'] as num?)?.toInt(),
      isEditable: (json['isEditable'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EntityStageConfigurationToJson(
        EntityStageConfiguration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stage': instance.stage,
      'status': instance.status,
      'order': instance.order,
      'isEditable': instance.isEditable,
    };
