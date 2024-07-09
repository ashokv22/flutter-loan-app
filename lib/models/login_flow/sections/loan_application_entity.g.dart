// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanApplicationEntity _$LoanApplicationEntityFromJson(
        Map<String, dynamic> json) =>
    LoanApplicationEntity(
      id: (json['id'] as num).toInt(),
      entityType: json['entityType'] as String,
      entitySubType: json['entitySubType'] as String,
      displayTitle: json['displayTitle'] as String,
      entityName: json['entityName'] as String,
      entityIdGeneration: json['entityIdGeneration'] as String,
      entitySequence: json['entitySequence'] as String,
      cssClassName: json['cssClassName'] as String,
      loanSections: (json['loanSections'] as List<dynamic>)
          .map((e) => LoanSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoanApplicationEntityToJson(
        LoanApplicationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entitySubType': instance.entitySubType,
      'displayTitle': instance.displayTitle,
      'entityName': instance.entityName,
      'entityIdGeneration': instance.entityIdGeneration,
      'entitySequence': instance.entitySequence,
      'cssClassName': instance.cssClassName,
      'loanSections': instance.loanSections,
    };

LoanSection _$LoanSectionFromJson(Map<String, dynamic> json) => LoanSection(
      id: (json['id'] as num?)?.toInt(),
      sectionName: json['sectionName'] as String,
      displayTitle: json['displayTitle'] as String,
      status: json['status'] as String,
      type: json['type'] as String?,
      uiKey: json['uiKey'] as String?,
      dependencies: (json['dependencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LoanSectionToJson(LoanSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sectionName': instance.sectionName,
      'displayTitle': instance.displayTitle,
      'status': instance.status,
      'type': instance.type,
      'uiKey': instance.uiKey,
      'dependencies': instance.dependencies,
    };
