// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_checklist_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentChecklistDTO _$DocumentChecklistDTOFromJson(
        Map<String, dynamic> json) =>
    DocumentChecklistDTO(
      id: json['id'] as int,
      documentName: json['documentName'] as String,
      documentDescription: json['documentDescription'] as String,
      category: $enumDecode(_$DocumentCategoryEnumMap, json['category']),
      isMandatory: json['isMandatory'] as bool,
      productId: json['productId'] as int,
      isKycDocument: json['isKycDocument'] as bool?,
      vendorDocumentName: json['vendorDocumentName'] as String?,
      kycCategory: json['kycCategory'] as String?,
      uploadedDocuments: (json['uploadedDocuments'] as List<dynamic>?)
          ?.map((e) => ApplicationDocuments.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocumentChecklistDTOToJson(
        DocumentChecklistDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentName': instance.documentName,
      'documentDescription': instance.documentDescription,
      'category': _$DocumentCategoryEnumMap[instance.category]!,
      'isMandatory': instance.isMandatory,
      'productId': instance.productId,
      'isKycDocument': instance.isKycDocument,
      'vendorDocumentName': instance.vendorDocumentName,
      'kycCategory': instance.kycCategory,
      'uploadedDocuments': instance.uploadedDocuments,
    };

const _$DocumentCategoryEnumMap = {
  DocumentCategory.PRE_SANCTION: 'PRE_SANCTION',
  DocumentCategory.POST_SANCTION: 'POST_SANCTION',
};
