// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_specification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentSpecificationDTO _$DocumentSpecificationDTOFromJson(
        Map<String, dynamic> json) =>
    DocumentSpecificationDTO(
      category: $enumDecode(_$DocumentCategoryEnumMap, json['category']),
      productId: json['productId'] as int,
      isMandatory: json['isMandatory'] as bool?,
    );

Map<String, dynamic> _$DocumentSpecificationDTOToJson(
        DocumentSpecificationDTO instance) =>
    <String, dynamic>{
      'category': _$DocumentCategoryEnumMap[instance.category]!,
      'productId': instance.productId,
      'isMandatory': instance.isMandatory,
    };

const _$DocumentCategoryEnumMap = {
  DocumentCategory.PRE_SANCTION: 'PRE_SANCTION',
  DocumentCategory.POST_SANCTION: 'POST_SANCTION',
};
