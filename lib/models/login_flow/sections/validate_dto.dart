// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class ValidateDTO {
  int CustID;
  String CustOTP;
  String CustMobileNo;
  ValidateDTO({
    required this.CustID,
    required this.CustOTP,
    required this.CustMobileNo,
  });

  ValidateDTO copyWith({
    int? CustID,
    String? CustOTP,
    String? CustMobileNo,
  }) {
    return ValidateDTO(
      CustID: CustID ?? this.CustID,
      CustOTP: CustOTP ?? this.CustOTP,
      CustMobileNo: CustMobileNo ?? this.CustMobileNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'CustID': CustID,
      'CustOTP': CustOTP,
      'CustMobileNo': CustMobileNo,
    };
  }

  factory ValidateDTO.fromMap(Map<String, dynamic> map) {
    return ValidateDTO(
      CustID: map['CustID'] as int,
      CustOTP: map['CustOTP'] as String,
      CustMobileNo: map['CustMobileNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ValidateDTO.fromJson(String source) => ValidateDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ValidateDTO(CustID: $CustID, CustOTP: $CustOTP, CustMobileNo: $CustMobileNo)';

  @override
  bool operator ==(covariant ValidateDTO other) {
    if (identical(this, other)) return true;
  
    return 
      other.CustID == CustID &&
      other.CustOTP == CustOTP &&
      other.CustMobileNo == CustMobileNo;
  }

  @override
  int get hashCode => CustID.hashCode ^ CustOTP.hashCode ^ CustMobileNo.hashCode;
}
