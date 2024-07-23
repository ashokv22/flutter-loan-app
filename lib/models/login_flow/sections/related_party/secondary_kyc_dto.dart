
import 'package:json_annotation/json_annotation.dart';

part 'secondary_kyc_dto.g.dart';

@JsonSerializable()
class SecondaryKYCDTO {
  int? id;
  int relatedPartyId;
  String kycType;
  String? panNumber;
  String name;
  String? fatherName;
  DateTime? dateOfBirth;
  bool isVerified;
  int? form60Id;
  SecondaryKYCDTO({
    this.id,
    required this.relatedPartyId,
    required this.kycType,
    this.panNumber,
    required this.name,
    this.fatherName,
    this.dateOfBirth,
    required this.isVerified,
    this.form60Id,
  });

  factory SecondaryKYCDTO.fromJson(Map<String, dynamic> json) => _$SecondaryKYCDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SecondaryKYCDTOToJson(this);
}
