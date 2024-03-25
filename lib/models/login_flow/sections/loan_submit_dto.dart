// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:origination/models/login_flow/sections/nominee_details.dart';
import 'package:origination/models/login_flow/sections/validate_dto.dart';

class LoanSubmitDTO {
  ValidateDTO validateDTO;
  NomineeDetails nomineeDetailsDTO;
  LoanSubmitDTO({
    required this.validateDTO,
    required this.nomineeDetailsDTO,
  });

  LoanSubmitDTO copyWith({
    ValidateDTO? validateDTO,
    NomineeDetails? nomineeDetailsDTO,
  }) {
    return LoanSubmitDTO(
      validateDTO: validateDTO ?? this.validateDTO,
      nomineeDetailsDTO: nomineeDetailsDTO ?? this.nomineeDetailsDTO,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'validateDTO': validateDTO.toMap(),
      'nomineeDetailsDTO': nomineeDetailsDTO.toMap(),
    };
  }

  factory LoanSubmitDTO.fromMap(Map<String, dynamic> map) {
    return LoanSubmitDTO(
      validateDTO: ValidateDTO.fromMap(map['validateDTO'] as Map<String,dynamic>),
      nomineeDetailsDTO: NomineeDetails.fromMap(map['nomineeDetailsDTO'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoanSubmitDTO.fromJson(String source) => LoanSubmitDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoanSubmitDTO(validateDTO: $validateDTO, nomineeDetailsDTO: $nomineeDetailsDTO)';

  @override
  bool operator ==(covariant LoanSubmitDTO other) {
    if (identical(this, other)) return true;
  
    return 
      other.validateDTO == validateDTO &&
      other.nomineeDetailsDTO == nomineeDetailsDTO;
  }

  @override
  int get hashCode => validateDTO.hashCode ^ nomineeDetailsDTO.hashCode;
}
