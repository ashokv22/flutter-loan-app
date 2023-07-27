import 'package:json_annotation/json_annotation.dart';
import 'package:origination/models/bureau_check/otp_verification/otp_request_dto.dart';
import 'package:origination/models/bureau_check/save_declaration_dto.dart';

part 'otp_validation_dto.g.dart';

@JsonSerializable()
class OtpValidationDTO {
  OtpRequestDTO? requestDTO;
  SaveDeclarationDTO? declarationDTO;

  OtpValidationDTO({
    this.requestDTO,
    this.declarationDTO,
  });

  factory OtpValidationDTO.fromJson(Map<String, dynamic> json) => _$OtpValidationDTOFromJson(json);
  Map<String, dynamic> toJson() => _$OtpValidationDTOToJson(this);

}