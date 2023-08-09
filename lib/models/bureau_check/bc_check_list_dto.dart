
import 'package:json_annotation/json_annotation.dart';

part 'bc_check_list_dto.g.dart';

@JsonSerializable()
class CheckListDTO {
  int id;
  CibilType type;
  String name;
  String status;

  CheckListDTO({
    required this.id,
    required this.type,
    required this.name,
    required this.status
  });

  factory CheckListDTO.fromJson(Map<String, dynamic> json) => _$CheckListDTOFromJson(json);
  Map<String, dynamic> toJson() => _$CheckListDTOToJson(this);

}

enum CibilType {
  APPLICANT,
  CO_APPLICANT,
  GUARANTOR,
  COMMERCIAL
}