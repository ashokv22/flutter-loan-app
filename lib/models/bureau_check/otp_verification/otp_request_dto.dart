import 'package:json_annotation/json_annotation.dart';

part 'otp_request_dto.g.dart';

@JsonSerializable()
class OtpRequestDTO {
  String? otp;
  String? secret_key;

  OtpRequestDTO({
    this.otp,
    this.secret_key,
  });

  factory OtpRequestDTO.fromJson(Map<String, dynamic> json) => _$OtpRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$OtpRequestDTOToJson(this);

}