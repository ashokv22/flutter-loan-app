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
  String? trueLabel;
  String? falseLabel;

  FieldUiProperties({
    this.id,
    this.uiComponentName,
    this.isMultiselect,
    this.displayKey,
    this.valueKey,
    this.cssClassName,
    this.patternForValidation,
    this.trueLabel,
    this.falseLabel,
  });

  factory FieldUiProperties.fromJson(Map<String, dynamic> json) =>
      _$FieldUiPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$FieldUiPropertiesToJson(this);
}

@JsonSerializable()
class FieldMeta {
  String? fieldName;
  String? displayTitle;
  String? dataType;
  AddressDetails? addressDetails;
  String? referenceCodeClassifier;
  String? apiForOptions;
  String? variable;
  int? noOfDecimalDigits;
  FieldUiProperties? fieldUiProperties;

  FieldMeta({
    this.fieldName,
    this.displayTitle,
    this.dataType,
    this.addressDetails,
    this.referenceCodeClassifier,
    this.apiForOptions,
    this.variable,
    this.noOfDecimalDigits,
    this.fieldUiProperties,
  });

  factory FieldMeta.fromJson(Map<String, dynamic> json) => _$FieldMetaFromJson(json);

  Map<String, dynamic> toJson() => _$FieldMetaToJson(this);
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
}

@JsonSerializable()
class Section {
  dynamic id;
  String? sectionName;
  String? displayTitle;
  String? cssClassName;
  int? order;
  MetaData? metaData;
  List<SubSection>? subSections;

  Section({
    this.id,
    this.sectionName,
    this.displayTitle,
    this.cssClassName,
    this.order,
    this.metaData,
    this.subSections,
  });

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

  Map<String, dynamic> toJson() => _$SectionToJson(this);
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
}

@JsonSerializable()
class MetaData {
  int? noOfFields;
  int? mandatory;
  int? dataCaptured;

  MetaData({
    this.noOfFields,
    this.mandatory,
    this.dataCaptured,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) =>
    _$MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
}

@JsonSerializable()
class AddressDetails {
  String addressType;
  String addressLine1;
  String? addressLine2;
  String city;
  String taluka;
  String district;
  String state;
  String country;
  String pinCode;

  AddressDetails({
    required this.addressType,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.taluka,
    required this.district,
    required this.state,
    required this.country,
    required this.pinCode
  });

    factory AddressDetails.fromJson(Map<String, dynamic> json) =>
    _$AddressDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDetailsToJson(this);

}
