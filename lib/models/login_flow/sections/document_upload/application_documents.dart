import 'package:json_annotation/json_annotation.dart';

part 'application_documents.g.dart';

@JsonSerializable()
class ApplicationDocuments {
  final int id;
  final int documentChecklistId;
  final String documentName;
  final String documentDescription;
  final int fileId;
  final int applicationId;
  final int productId;
  final String? status;
  final bool? isKycDocument;
  final String? vendorDocumentName;
  final String? kycCategory;

  ApplicationDocuments({
    required this.id,
    required this.documentChecklistId,
    required this.documentName,
    required this.documentDescription,
    required this.fileId,
    required this.applicationId,
    required this.productId,
    this.status,
    this.isKycDocument,
    this.vendorDocumentName,
    this.kycCategory,
  });

  factory ApplicationDocuments.fromJson(Map<String, dynamic> json) => _$ApplicationDocumentsFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationDocumentsToJson(this);

}