// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_documents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationDocuments _$ApplicationDocumentsFromJson(
        Map<String, dynamic> json) =>
    ApplicationDocuments(
      id: json['id'] as int,
      documentChecklistId: json['documentChecklistId'] as int,
      documentName: json['documentName'] as String,
      documentDescription: json['documentDescription'] as String,
      fileId: json['fileId'] as int,
      applicationId: json['applicationId'] as int,
      productId: json['productId'] as int,
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
