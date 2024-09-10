import 'package:origination/models/login_flow/sections/document_upload/application_documents.dart';
import 'package:origination/models/login_flow/sections/document_upload/document_specification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_checklist_dto.g.dart';

@JsonSerializable()
class DocumentChecklistDTO {
  int id;
  String documentName;
  String documentDescription;
  DocumentCategory category;
  bool isMandatory;
  int productId;
  bool? isKycDocument;
  String? vendorDocumentName;
  String? kycCategory;
  EntityTypes? entityTypes;
  UploadType? uploadType;
  List<String>? supportedExtensions;
  bool? isUpload;
  List<ApplicationDocuments>? uploadedDocuments;

  DocumentChecklistDTO({
    required this.id,
    required this.documentName,
    required this.documentDescription,
    required this.category,
    required this.isMandatory,
    required this.productId,
    this.isKycDocument,
    this.vendorDocumentName,
    this.kycCategory,
    this.entityTypes,
    this.uploadType,
    this.supportedExtensions,
    this.isUpload,
    this.uploadedDocuments,
  });

  factory DocumentChecklistDTO.fromJson(Map<String, dynamic> json) => _$DocumentChecklistDTOFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentChecklistDTOToJson(this);

}

enum UploadType {
    CAPTURE, UPLOAD, BOTH, VIEW;
}