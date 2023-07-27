
import 'package:json_annotation/json_annotation.dart';

part 'declaration.g.dart';

@JsonSerializable()
class DeclarationMasterDTO {
  int id;
  String entityType;
  String declarationContent;
  DateTime fromDate;
  DateTime toDate;
  bool isActive;

  DeclarationMasterDTO({
    required this.id,
    required this.entityType,
    required this.declarationContent,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
  });

  factory DeclarationMasterDTO.fromJson(Map<String, dynamic> json) => _$DeclarationMasterDTOFromJson(json);
  Map<String, dynamic> toJson() => _$DeclarationMasterDTOToJson(this);
}