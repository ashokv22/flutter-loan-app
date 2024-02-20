
import 'package:json_annotation/json_annotation.dart';

part 'secondary_kyc_dto.g.dart';

@JsonSerializable()
class SecondaryKYCDTO {
  int id;
  int relatedPartyId;
  String panNumber;
  String name;
  String? fatherName;
  DateTime dateOfBirth;
  bool isVerified;
  SecondaryKYCDTO({
    required this.id,
    required this.relatedPartyId,
    required this.panNumber,
    required this.name,
    this.fatherName,
    required this.dateOfBirth,
    required this.isVerified,
  });

  factory SecondaryKYCDTO.fromJson(Map<String, dynamic> json) => _$SecondaryKYCDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SecondaryKYCDTOToJson(this);
}
