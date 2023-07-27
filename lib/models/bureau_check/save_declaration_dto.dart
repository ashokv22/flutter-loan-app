import 'package:json_annotation/json_annotation.dart';

part 'save_declaration_dto.g.dart';


@JsonSerializable()
class SaveDeclarationDTO {
  int? id;
  String? entityType;
  int? entityId;
  String? modeOfAcceptance;
  DateTime? dateOfAcceptance;
  String? status;
  int? declarationMasterId;

  SaveDeclarationDTO({
    this.id,
    this.entityType,
    this.entityId,
    this.modeOfAcceptance,
    this.dateOfAcceptance,
    this.status,
    this.declarationMasterId
  });

  factory SaveDeclarationDTO.fromJson(Map<String, dynamic> json) => _$SaveDeclarationDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SaveDeclarationDTOToJson(this);

}