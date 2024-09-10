// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_checklist_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentChecklistDTO _$DocumentChecklistDTOFromJson(
        Map<String, dynamic> json) =>
    DocumentChecklistDTO(
      id: (json['id'] as num).toInt(),
      documentName: json['documentName'] as String,
      documentDescription: json['documentDescription'] as String,
      category: $enumDecode(_$DocumentCategoryEnumMap, json['category']),
      isMandatory: json['isMandatory'] as bool,
      productId: (json['productId'] as num).toInt(),
      isKycDocument: json['isKycDocument'] as bool?,
      vendorDocumentName: json['vendorDocumentName'] as String?,
      kycCategory: json['kycCategory'] as String?,
      entityTypes:
          $enumDecodeNullable(_$EntityTypesEnumMap, json['entityTypes']),
      uploadType: $enumDecodeNullable(_$UploadTypeEnumMap, json['uploadType']),
      supportedExtensions: (json['supportedExtensions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isUpload: json['isUpload'] as bool?,
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
      'entityTypes': _$EntityTypesEnumMap[instance.entityTypes],
      'uploadType': _$UploadTypeEnumMap[instance.uploadType],
      'supportedExtensions': instance.supportedExtensions,
      'isUpload': instance.isUpload,
      'uploadedDocuments': instance.uploadedDocuments,
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

const _$UploadTypeEnumMap = {
  UploadType.CAPTURE: 'CAPTURE',
  UploadType.UPLOAD: 'UPLOAD',
  UploadType.BOTH: 'BOTH',
  UploadType.VIEW: 'VIEW',
};
