// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpResponseDTO _$OtpResponseDTOFromJson(Map<String, dynamic> json) =>
    OtpResponseDTO(
      message: json['message'] as String?,
      statusCode: json['statusCode'] as String?,
    );

Map<String, dynamic> _$OtpResponseDTOToJson(OtpResponseDTO instance) =>
    <String, dynamic>{
      'message': instance.message,
      'statusCode': instance.statusCode,
    };
