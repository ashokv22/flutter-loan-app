import 'package:json_annotation/json_annotation.dart';

part 'entity_configuration.g.dart';

@JsonSerializable()
class EntityConfigurationMetaData {
  int? id;
  String? entityType;
  String? entitySubType;
  String? displayTitle;
  String? entityName;
  String? entityIdGeneration;
  String? entitySequence;
  String? cssClassName;
  List<Section>? sections;

  EntityConfigurationMetaData({
    this.id,
    this.entityType,
    this.entitySubType,
    this.displayTitle,
    this.entityName,
    this.entityIdGeneration,
    this.entitySequence,
    this.cssClassName,
    this.sections,
  });

  factory EntityConfigurationMetaData.fromJson(Map<String, dynamic> json) =>
      _$EntityConfigurationMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$EntityConfigurationMetaDataToJson(this);


  // factory EntityConfigurationMetaData.fromJson(Map<String, dynamic> json) {
  //   return EntityConfigurationMetaData(
  //     id: json['id'],
  //     entityType: json['entityType'],
  //     entitySubType: json['entitySubType'],
  //     displayTitle: json['displayTitle'],
  //     entityName: json['entityName'],
  //     entityIdGeneration: json['entityIdGeneration'],
  //     entitySequence: json['entitySequence'],
  //     cssClassName: json['cssClassName'],
  //     sections: (json['sections'] as List<dynamic>?)
  //         ?.map((sectionJson) =>
  //             Section.fromJson(sectionJson as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'entityType': entityType,
  //     'entitySubType': entitySubType,
  //     'displayTitle': displayTitle,
  //     'entityName': entityName,
  //     'entityIdGeneration': entityIdGeneration,
  //     'entitySequence': entitySequence,
  //     'cssClassName': cssClassName,
  //     'sections': sections?.map((section) => section.toJson()).toList(),
  //   };
  // }
}

@JsonSerializable()
class UiComponentMasterDTO {
  dynamic id;
  String? name;
  String? fieldDataTypes;

  UiComponentMasterDTO({
    this.id,
    this.name,
    this.fieldDataTypes,
  });

  factory UiComponentMasterDTO.fromJson(Map<String, dynamic> json) =>
      _$UiComponentMasterDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UiComponentMasterDTOToJson(this);

  // factory UiComponentMasterDTO.fromJson(Map<String, dynamic> json) {
  //   return UiComponentMasterDTO(
  //     id: json['id'],
  //     name: json['name'],
  //     fieldDataTypes: json['fieldDataTypes'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'fieldDataTypes': fieldDataTypes,
  //   };
  // }
}

@JsonSerializable()
class FieldUiProperties {
  dynamic id;
  String? uiComponentName;
  bool? isMultiselect;
  String? displayKey;
  String? valueKey;
  String? cssClassName;
  String? patternForValidation;

  FieldUiProperties({
    this.id,
    this.uiComponentName,
    this.isMultiselect,
    this.displayKey,
    this.valueKey,
    this.cssClassName,
    this.patternForValidation,
  });

  factory FieldUiProperties.fromJson(Map<String, dynamic> json) =>
      _$FieldUiPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$FieldUiPropertiesToJson(this);

  // factory FieldUiProperties.fromJson(Map<String, dynamic> json) {
  //   return FieldUiProperties(
  //     id: json['id'],
  //     uiComponentName: json['uiComponentName'],
  //     isMultiselect: json['isMultiselect'],
  //     displayKey: json['displayKey'],
  //     valueKey: json['valueKey'],
  //     cssClassName: json['cssClassName'],
  //     patternForValidation: json['patternForValidation'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'uiComponentName': uiComponentName,
  //     'isMultiselect': isMultiselect,
  //     'displayKey': displayKey,
  //     'valueKey': valueKey,
  //     'cssClassName': cssClassName,
  //     'patternForValidation': patternForValidation,
  //   };
  // }
}

@JsonSerializable()
class FieldMeta {
  String? fieldName;
  String? displayTitle;
  String? dataType;
  String? referenceCodeClassifier;
  String? apiForOptions;
  String? variable;
  int? noOfDecimalDigits;
  FieldUiProperties? fieldUiProperties;

  FieldMeta({
    this.fieldName,
    this.displayTitle,
    this.dataType,
    this.referenceCodeClassifier,
    this.apiForOptions,
    this.variable,
    this.noOfDecimalDigits,
    this.fieldUiProperties,
  });

  factory FieldMeta.fromJson(Map<String, dynamic> json) => _$FieldMetaFromJson(json);

  Map<String, dynamic> toJson() => _$FieldMetaToJson(this);

  // factory FieldMeta.fromJson(Map<String, dynamic> json) {
  //   return FieldMeta(
  //     fieldName: json['fieldName'],
  //     displayTitle: json['displayTitle'],
  //     dataType: json['dataType'],
  //     referenceCodeClassifier: json['referenceCodeClassifier'],
  //     apiForOptions: json['apiForOptions'],
  //     variable: json['variable'],
  //     noOfDecimalDigits: json['noOfDecimalDigits'],
  //     fieldUiProperties: FieldUiProperties.fromJson(
  //         json['fieldUiProperties'] as Map<String, dynamic>),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'fieldName': fieldName,
  //     'displayTitle': displayTitle,
  //     'dataType': dataType,
  //     'referenceCodeClassifier': referenceCodeClassifier,
  //     'apiForOptions': apiForOptions,
  //     'variable': variable,
  //     'noOfDecimalDigits': noOfDecimalDigits,
  //     'fieldUiProperties': fieldUiProperties?.toJson(),
  //   };
  // }
}

@JsonSerializable()
class Field {
  dynamic id;
  int? order;
  bool? isRequired;
  bool? isReadOnly;
  bool? isEditable;
  bool? conditionalMandatory;
  String? conditionOnField;
  dynamic businessValidation;
  dynamic businessValidationNotation;
  String? baseCssClassName;
  FieldMeta? fieldMeta;
  String? value;
  String? prepopulateVariable;
  String? prepopulateKey;

  Field({
    this.id,
    this.order,
    this.isRequired,
    this.isReadOnly,
    this.isEditable,
    this.conditionalMandatory,
    this.conditionOnField,
    this.businessValidation,
    this.businessValidationNotation,
    this.baseCssClassName,
    this.fieldMeta,
    this.value,
    this.prepopulateVariable,
    this.prepopulateKey,
  });

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);

  // factory Field.fromJson(Map<String, dynamic> json) {
  //   return Field(
  //     id: json['id'],
  //     order: json['order'],
  //     isRequired: json['isRequired'],
  //     isReadOnly: json['isReadOnly'],
  //     isEditable: json['isEditable'],
  //     conditionalMandatory: json['conditionalMandatory'],
  //     conditionOnField: json['conditionOnField'],
  //     businessValidation: json['businessValidation'],
  //     businessValidationNotation: json['businessValidationNotation'],
  //     baseCssClassName: json['baseCssClassName'],
  //     fieldMeta:
  //         FieldMeta.fromJson(json['fieldMeta'] as Map<String, dynamic>),
  //     value: json['value'],
  //     prepopulateVariable: json['prepopulateVariable'],
  //     prepopulateKey: json['prepopulateKey'],
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'order': order,
  //     'isRequired': isRequired,
  //     'isReadOnly': isReadOnly,
  //     'isEditable': isEditable,
  //     'conditionalMandatory': conditionalMandatory,
  //     'conditionOnField': conditionOnField,
  //     'businessValidation': businessValidation,
  //     'businessValidationNotation': businessValidationNotation,
  //     'baseCssClassName': baseCssClassName,
  //     'fieldMeta': fieldMeta?.toJson(),
  //     'value': value,
  //     'prepopulateVariable': prepopulateVariable,
  //     'prepopulateKey': prepopulateKey,
  //   };
  // }
}

@JsonSerializable()
class Section {
  dynamic id;
  String? sectionName;
  String? displayTitle;
  String? cssClassName;
  int? order;
  List<SubSection>? subSections;

  Section({
    this.id,
    this.sectionName,
    this.displayTitle,
    this.cssClassName,
    this.order,
    this.subSections,
  });

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);

  // factory Section.fromJson(Map<String, dynamic> json) {
  //   return Section(
  //     id: json['id'],
  //     sectionName: json['sectionName'],
  //     displayTitle: json['displayTitle'],
  //     cssClassName: json['cssClassName'],
  //     order: json['order'],
  //     subSections: (json['subSections'] as List<dynamic>?)
  //         ?.map(
  //             (subSectionJson) => SubSection.fromJson(subSectionJson as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'sectionName': sectionName,
  //     'displayTitle': displayTitle,
  //     'cssClassName': cssClassName,
  //     'order': order,
  //     'subSections': subSections?.map((subSection) => subSection.toJson()).toList(),
  //   };
  // }
}

@JsonSerializable()
class SubSection {
  dynamic id;
  String? subSectionName;
  String? displayTitle;
  String? cssClassName;
  bool? isRepeatable;
  int? maxNumberOfRepeatableSections;
  int? order;
  List<Field>? fields;

  SubSection({
    this.id,
    this.subSectionName,
    this.displayTitle,
    this.cssClassName,
    this.isRepeatable,
    this.maxNumberOfRepeatableSections,
    this.order,
    this.fields,
  });

  factory SubSection.fromJson(Map<String, dynamic> json) =>
      _$SubSectionFromJson(json);

  Map<String, dynamic> toJson() => _$SubSectionToJson(this);

  // factory SubSection.fromJson(Map<String, dynamic> json) {
  //   return SubSection(
  //     id: json['id'],
  //     subSectionName: json['subSectionName'],
  //     displayTitle: json['displayTitle'],
  //     cssClassName: json['cssClassName'],
  //     isRepeatable: json['isRepeatable'],
  //     maxNumberOfRepeatableSections: json['maxNumberOfRepeatableSections'],
  //     order: json['order'],
  //     fields: (json['fields'] as List<dynamic>?)
  //         ?.map((fieldJson) => Field.fromJson(fieldJson as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'subSectionName': subSectionName,
  //     'displayTitle': displayTitle,
  //     'cssClassName': cssClassName,
  //     'isRepeatable': isRepeatable,
  //     'maxNumberOfRepeatableSections': maxNumberOfRepeatableSections,
  //     'order': order,
  //     'fields': fields?.map((field) => field.toJson()).toList(),
  //   };
  // }
}
