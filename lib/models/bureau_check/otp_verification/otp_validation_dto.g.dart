// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_validation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpValidationDTO _$OtpValidationDTOFromJson(Map<String, dynamic> json) =>
    OtpValidationDTO(
      requestDTO: json['requestDTO'] == null
          ? null
          : OtpRequestDTO.fromJson(json['requestDTO'] as Map<String, dynamic>),
      declarationDTO: json['declarationDTO'] == null
          ? null
          : SaveDeclarationDTO.fromJson(
              json['declarationDTO'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpValidationDTOToJson(OtpValidationDTO instance) =>
    <String, dynamic>{
      'requestDTO': instance.requestDTO,
      'declarationDTO': instance.declarationDTO,
    };
