// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityConfigurationMetaData _$EntityConfigurationMetaDataFromJson(
        Map<String, dynamic> json) =>
    EntityConfigurationMetaData(
      id: json['id'] as int?,
      entityType: json['entityType'] as String?,
      entitySubType: json['entitySubType'] as String?,
      displayTitle: json['displayTitle'] as String?,
      entityName: json['entityName'] as String?,
      entityIdGeneration: json['entityIdGeneration'] as String?,
      entitySequence: json['entitySequence'] as String?,
      cssClassName: json['cssClassName'] as String?,
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntityConfigurationMetaDataToJson(
        EntityConfigurationMetaData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entitySubType': instance.entitySubType,
      'displayTitle': instance.displayTitle,
      'entityName': instance.entityName,
      'entityIdGeneration': instance.entityIdGeneration,
      'entitySequence': instance.entitySequence,
      'cssClassName': instance.cssClassName,
      'sections': instance.sections,
    };

UiComponentMasterDTO _$UiComponentMasterDTOFromJson(
        Map<String, dynamic> json) =>
    UiComponentMasterDTO(
      id: json['id'],
      name: json['name'] as String?,
      fieldDataTypes: json['fieldDataTypes'] as String?,
    );

Map<String, dynamic> _$UiComponentMasterDTOToJson(
        UiComponentMasterDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fieldDataTypes': instance.fieldDataTypes,
    };

FieldUiProperties _$FieldUiPropertiesFromJson(Map<String, dynamic> json) =>
    FieldUiProperties(
      id: json['id'],
      uiComponentName: json['uiComponentName'] as String?,
      isMultiselect: json['isMultiselect'] as bool?,
      displayKey: json['displayKey'] as String?,
      valueKey: json['valueKey'] as String?,
      cssClassName: json['cssClassName'] as String?,
      patternForValidation: json['patternForValidation'] as String?,
      trueLabel: json['trueLabel'] as String?,
      falseLabel: json['falseLabel'] as String?,
    );

Map<String, dynamic> _$FieldUiPropertiesToJson(FieldUiProperties instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uiComponentName': instance.uiComponentName,
      'isMultiselect': instance.isMultiselect,
      'displayKey': instance.displayKey,
      'valueKey': instance.valueKey,
      'cssClassName': instance.cssClassName,
      'patternForValidation': instance.patternForValidation,
      'trueLabel': instance.trueLabel,
      'falseLabel': instance.falseLabel,
    };

FieldMeta _$FieldMetaFromJson(Map<String, dynamic> json) => FieldMeta(
      fieldName: json['fieldName'] as String?,
      displayTitle: json['displayTitle'] as String?,
      dataType: json['dataType'] as String?,
      referenceCodeClassifier: json['referenceCodeClassifier'] as String?,
      apiForOptions: json['apiForOptions'] as String?,
      variable: json['variable'] as String?,
      noOfDecimalDigits: json['noOfDecimalDigits'] as int?,
      fieldUiProperties: json['fieldUiProperties'] == null
          ? null
          : FieldUiProperties.fromJson(
              json['fieldUiProperties'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FieldMetaToJson(FieldMeta instance) => <String, dynamic>{
      'fieldName': instance.fieldName,
      'displayTitle': instance.displayTitle,
      'dataType': instance.dataType,
      'referenceCodeClassifier': instance.referenceCodeClassifier,
      'apiForOptions': instance.apiForOptions,
      'variable': instance.variable,
      'noOfDecimalDigits': instance.noOfDecimalDigits,
      'fieldUiProperties': instance.fieldUiProperties,
    };

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      id: json['id'],
      order: json['order'] as int?,
      isRequired: json['isRequired'] as bool?,
      isReadOnly: json['isReadOnly'] as bool?,
      isEditable: json['isEditable'] as bool?,
      conditionalMandatory: json['conditionalMandatory'] as bool?,
      conditionOnField: json['conditionOnField'] as String?,
      businessValidation: json['businessValidation'],
      businessValidationNotation: json['businessValidationNotation'],
      baseCssClassName: json['baseCssClassName'] as String?,
      fieldMeta: json['fieldMeta'] == null
          ? null
          : FieldMeta.fromJson(json['fieldMeta'] as Map<String, dynamic>),
      value: json['value'] as String?,
      prepopulateVariable: json['prepopulateVariable'] as String?,
      prepopulateKey: json['prepopulateKey'] as String?,
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'isRequired': instance.isRequired,
      'isReadOnly': instance.isReadOnly,
      'isEditable': instance.isEditable,
      'conditionalMandatory': instance.conditionalMandatory,
      'conditionOnField': instance.conditionOnField,
      'businessValidation': instance.businessValidation,
      'businessValidationNotation': instance.businessValidationNotation,
      'baseCssClassName': instance.baseCssClassName,
      'fieldMeta': instance.fieldMeta,
      'value': instance.value,
      'prepopulateVariable': instance.prepopulateVariable,
      'prepopulateKey': instance.prepopulateKey,
    };

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      id: json['id'],
      sectionName: json['sectionName'] as String?,
      displayTitle: json['displayTitle'] as String?,
      cssClassName: json['cssClassName'] as String?,
      order: json['order'] as int?,
      metaData: json['metaData'] == null
          ? null
          : MetaData.fromJson(json['metaData'] as Map<String, dynamic>),
      subSections: (json['subSections'] as List<dynamic>?)
          ?.map((e) => SubSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'id': instance.id,
      'sectionName': instance.sectionName,
      'displayTitle': instance.displayTitle,
      'cssClassName': instance.cssClassName,
      'order': instance.order,
      'metaData': instance.metaData,
      'subSections': instance.subSections,
    };

SubSection _$SubSectionFromJson(Map<String, dynamic> json) => SubSection(
      id: json['id'],
      subSectionName: json['subSectionName'] as String?,
      displayTitle: json['displayTitle'] as String?,
      cssClassName: json['cssClassName'] as String?,
      isRepeatable: json['isRepeatable'] as bool?,
      maxNumberOfRepeatableSections:
          json['maxNumberOfRepeatableSections'] as int?,
      order: json['order'] as int?,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubSectionToJson(SubSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subSectionName': instance.subSectionName,
      'displayTitle': instance.displayTitle,
      'cssClassName': instance.cssClassName,
      'isRepeatable': instance.isRepeatable,
      'maxNumberOfRepeatableSections': instance.maxNumberOfRepeatableSections,
      'order': instance.order,
      'fields': instance.fields,
    };

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      noOfFields: json['noOfFields'] as int?,
      mandatory: json['mandatory'] as int?,
      dataCaptured: json['dataCaptured'] as int?,
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'noOfFields': instance.noOfFields,
      'mandatory': instance.mandatory,
      'dataCaptured': instance.dataCaptured,
    };
