import 'package:json_annotation/json_annotation.dart';

part 'pan_dto.g.dart';

@JsonSerializable()
class Pan {
  int relatedPartyId;
  String panNumber;
  String name;
  String fatherName;
  String dateOfBirth;
  bool isVerified;
  Pan({
    required this.relatedPartyId,
    required this.panNumber,
    required this.name,
    required this.fatherName,
    required this.dateOfBirth,
    required this.isVerified,
  });
  factory Pan.fromJson(Map<String, dynamic> json) => _$PanFromJson(json);
  Map<String, dynamic> toJson() => _$PanToJson(this);
}
