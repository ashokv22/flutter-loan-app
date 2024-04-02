
import 'package:json_annotation/json_annotation.dart';

part 'primary_kyc_dto.g.dart';

@JsonSerializable()
class PrimaryKycDTO {
  int? id;
  int relatedPartyId;
  String aadhaarNumber;
  String name;
  String? fatherName;
  String? dateOfBirth;
  String? yearOfBirth;
  String address;
  bool isVerified = true;
  String? photoBase64;

  PrimaryKycDTO({
    this.id,
    required this.relatedPartyId,
    required this.aadhaarNumber,
    required this.name,
    this.fatherName,
    this.dateOfBirth,
    this.yearOfBirth,
    required this.address,
    required this.isVerified,
    this.photoBase64,
  });

  factory PrimaryKycDTO.fromJson(Map<String, dynamic> json) => _$PrimaryKycDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PrimaryKycDTOToJson(this);

}