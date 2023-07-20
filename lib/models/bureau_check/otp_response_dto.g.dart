// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpResponseDTO _$OtpResponseDTOFromJson(Map<String, dynamic> json) =>
    OtpResponseDTO(
      otp: json['otp'] as String?,
      secret_key: json['secret_key'] as String?,
    );

Map<String, dynamic> _$OtpResponseDTOToJson(OtpResponseDTO instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'secret_key': instance.secret_key,
    };
