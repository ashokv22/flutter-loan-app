// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_specification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentSpecificationDTO _$DocumentSpecificationDTOFromJson(
        Map<String, dynamic> json) =>
    DocumentSpecificationDTO(
      category: $enumDecode(_$DocumentCategoryEnumMap, json['category']),
      productId: (json['productId'] as num).toInt(),
      isMandatory: json['isMandatory'] as bool?,
    )..entityTypes =
        $enumDecodeNullable(_$EntityTypesEnumMap, json['entityTypes']);

Map<String, dynamic> _$DocumentSpecificationDTOToJson(
        DocumentSpecificationDTO instance) =>
    <String, dynamic>{
      'category': _$DocumentCategoryEnumMap[instance.category]!,
      'productId': instance.productId,
      'isMandatory': instance.isMandatory,
      'entityTypes': _$EntityTypesEnumMap[instance.entityTypes],
    };

const _$DocumentCategoryEnumMap = {
  DocumentCategory.PRE_SANCTION: 'PRE_SANCTION',
  DocumentCategory.POST_SANCTION: 'POST_SANCTION',
  DocumentCategory.POST_DISBURSEMENT: 'POST_DISBURSEMENT',
  DocumentCategory.APPLICANT: 'APPLICANT',
};

const _$EntityTypesEnumMap = {
  EntityTypes.APPLICANT: 'APPLICANT',
  EntityTypes.CO_APPLICANT: 'CO_APPLICANT',
  EntityTypes.GUARANTOR: 'GUARANTOR',
  EntityTypes.LOAN: 'LOAN',
};
