import 'package:json_annotation/json_annotation.dart';

part 'otp_request_dto.g.dart';

@JsonSerializable()
class OtpRequestDTO {
  String? message;
  String? statusCode;

  OtpRequestDTO({
    this.message,
    this.statusCode,
  });

  factory OtpRequestDTO.fromJson(Map<String, dynamic> json) => _$OtpRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$OtpRequestDTOToJson(this);

}