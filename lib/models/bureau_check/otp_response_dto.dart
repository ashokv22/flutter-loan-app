import 'package:json_annotation/json_annotation.dart';

part 'otp_response_dto.g.dart';

@JsonSerializable()
class OtpResponseDTO {
  String? otp;
  String? secret_key;

  OtpResponseDTO({
    this.otp,
    this.secret_key,
  });

  factory OtpResponseDTO.fromJson(Map<String, dynamic> json) => _$OtpResponseDTOFromJson(json);
  Map<String, dynamic> toJson() => _$OtpResponseDTOToJson(this);

}