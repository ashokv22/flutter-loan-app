// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_documents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationDocuments _$ApplicationDocumentsFromJson(
        Map<String, dynamic> json) =>
    ApplicationDocuments(
      id: (json['id'] as num?)?.toInt(),
      documentChecklistId: (json['documentChecklistId'] as num?)?.toInt(),
      documentName: json['documentName'] as String?,
      documentDescription: json['documentDescription'] as String?,
      fileId: (json['fileId'] as num?)?.toInt(),
      applicationId: (json['applicationId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      status: json['status'] as String?,
      isKycDocument: json['isKycDocument'] as bool?,
      vendorDocumentName: json['vendorDocumentName'] as String?,
      kycCategory: json['kycCategory'] as String?,
    );

Map<String, dynamic> _$ApplicationDocumentsToJson(
        ApplicationDocuments instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentChecklistId': instance.documentChecklistId,
      'documentName': instance.documentName,
      'documentDescription': instance.documentDescription,
      'fileId': instance.fileId,
      'applicationId': instance.applicationId,
      'productId': instance.productId,
      'status': instance.status,
      'isKycDocument': instance.isKycDocument,
      'vendorDocumentName': instance.vendorDocumentName,
      'kycCategory': instance.kycCategory,
    };
