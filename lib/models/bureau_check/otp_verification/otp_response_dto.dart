import 'package:json_annotation/json_annotation.dart';

part 'otp_response_dto.g.dart';

@JsonSerializable()
class OtpResponseDTO {
  String? message;
  String? statusCode;

  OtpResponseDTO({
    this.message,
    this.statusCode,
  });

  factory OtpResponseDTO.fromJson(Map<String, dynamic> json) => _$OtpResponseDTOFromJson(json);
  Map<String, dynamic> toJson() => _$OtpResponseDTOToJson(this);

}