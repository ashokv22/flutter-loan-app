
import 'package:json_annotation/json_annotation.dart';

part 'primary_kyc_dto.g.dart';

@JsonSerializable()
class PrimaryKycDTO {
  int? id;
  int relatedPartyId;
  String adharNumber;
  String name;
  String fatherName;
  DateTime dateOfBirth;
  String address;

  PrimaryKycDTO({
    this.id,
    required this.relatedPartyId,
    required this.adharNumber,
    required this.name,
    required this.fatherName,
    required this.dateOfBirth,
    required this.address
  });

  factory PrimaryKycDTO.fromJson(Map<String, dynamic> json) => _$PrimaryKycDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PrimaryKycDTOToJson(this);

}