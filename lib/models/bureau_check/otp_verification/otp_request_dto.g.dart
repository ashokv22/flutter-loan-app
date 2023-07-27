// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestDTO _$OtpRequestDTOFromJson(Map<String, dynamic> json) =>
    OtpRequestDTO(
      otp: json['otp'] as String?,
      secret_key: json['secret_key'] as String?,
    );

Map<String, dynamic> _$OtpRequestDTOToJson(OtpRequestDTO instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'secret_key': instance.secret_key,
    };
