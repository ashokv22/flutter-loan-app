import 'package:json_annotation/json_annotation.dart';

part 'document_specification.g.dart';

@JsonSerializable()
class DocumentSpecificationDTO {
  DocumentCategory category;
  int productId;
  bool? isMandatory;
  EntityTypes? entityTypes;
  DocumentSpecificationDTO({
    required this.category,
    required this.productId,
    required this.isMandatory
  });

  
  factory DocumentSpecificationDTO.fromJson(Map<String, dynamic> json) => _$DocumentSpecificationDTOFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentSpecificationDTOToJson(this);

}

enum DocumentCategory {
  PRE_SANCTION, 
  POST_SANCTION,
  POST_DISBURSEMENT,
  APPLICANT
}

enum EntityTypes {
  APPLICANT,
  CO_APPLICANT,
  GUARANTOR,
  LOAN
}