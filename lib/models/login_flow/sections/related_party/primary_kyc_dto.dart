
import 'package:json_annotation/json_annotation.dart';

part 'primary_kyc_dto.g.dart';

@JsonSerializable()
class PrimaryKycDTO {
  int? id;
  int relatedPartyId;
  String aadhaarNumber;
  String name;
  String fatherName;
  DateTime dateOfBirth;
  String address;
  bool isVerified = true;

  PrimaryKycDTO({
    this.id,
    required this.relatedPartyId,
    required this.aadhaarNumber,
    required this.name,
    required this.fatherName,
    required this.dateOfBirth,
    required this.address,
    required this.isVerified,
  });

  factory PrimaryKycDTO.fromJson(Map<String, dynamic> json) => _$PrimaryKycDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PrimaryKycDTOToJson(this);

}