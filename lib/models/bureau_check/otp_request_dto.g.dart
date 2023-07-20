// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestDTO _$OtpRequestDTOFromJson(Map<String, dynamic> json) =>
    OtpRequestDTO(
      message: json['message'] as String?,
      statusCode: json['statusCode'] as String?,
    );

Map<String, dynamic> _$OtpRequestDTOToJson(OtpRequestDTO instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
    };
