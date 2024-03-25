import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NomineeDetails {
  String nomineeName;
  String addressLine1;
  String addressLine2;
  String landMark;
  String city;
  String taluka;
  String district;
  String state;
  String country;
  String pinCode;
  String relationshipWithApplicant;
  String dateOfBirth;
  int age;
  int applicantId;
  NomineeDetails({
    required this.nomineeName,
    required this.addressLine1,
    required this.addressLine2,
    required this.landMark,
    required this.city,
    required this.taluka,
    required this.district,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.relationshipWithApplicant,
    required this.dateOfBirth,
    required this.age,
    required this.applicantId,
  });

  NomineeDetails copyWith({
    String? nomineeName,
    String? addressLine1,
    String? addressLine2,
    String? landMark,
    String? city,
    String? taluka,
    String? district,
    String? state,
    String? country,
    String? pinCode,
    String? relationshipWithApplicant,
    String? dateOfBirth,
    int? age,
    int? applicantId,
  }) {
    return NomineeDetails(
      nomineeName: nomineeName ?? this.nomineeName,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      landMark: landMark ?? this.landMark,
      city: city ?? this.city,
      taluka: taluka ?? this.taluka,
      district: district ?? this.district,
      state: state ?? this.state,
      country: country ?? this.country,
      pinCode: pinCode ?? this.pinCode,
      relationshipWithApplicant: relationshipWithApplicant ?? this.relationshipWithApplicant,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      applicantId: applicantId ?? this.applicantId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomineeName': nomineeName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'landMark': landMark,
      'city': city,
      'taluka': taluka,
      'district': district,
      'state': state,
      'country': country,
      'pinCode': pinCode,
      'relationshipWithApplicant': relationshipWithApplicant,
      'dateOfBirth': dateOfBirth,
      'age': age,
      'applicantId': applicantId,
    };
  }

  factory NomineeDetails.fromMap(Map<String, dynamic> map) {
    return NomineeDetails(
      nomineeName: map['nomineeName'] as String,
      addressLine1: map['addressLine1'] as String,
      addressLine2: map['addressLine2'] as String,
      landMark: map['landMark'] as String,
      city: map['city'] as String,
      taluka: map['taluka'] as String,
      district: map['district'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      pinCode: map['pinCode'] as String,
      relationshipWithApplicant: map['relationshipWithApplicant'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      age: map['age'] as int,
      applicantId: map['applicantId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory NomineeDetails.fromJson(String source) => NomineeDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NomineeDetails(nomineeName: $nomineeName, addressLine1: $addressLine1, addressLine2: $addressLine2, landMark: $landMark, city: $city, taluka: $taluka, district: $district, state: $state, country: $country, pinCode: $pinCode, relationshipWithApplicant: $relationshipWithApplicant, dateOfBirth: $dateOfBirth, age: $age, applicantId: $applicantId)';
  }

  @override
  bool operator ==(covariant NomineeDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.nomineeName == nomineeName &&
      other.addressLine1 == addressLine1 &&
      other.addressLine2 == addressLine2 &&
      other.landMark == landMark &&
      other.city == city &&
      other.taluka == taluka &&
      other.district == district &&
      other.state == state &&
      other.country == country &&
      other.pinCode == pinCode &&
      other.relationshipWithApplicant == relationshipWithApplicant &&
      other.dateOfBirth == dateOfBirth &&
      other.age == age &&
      other.applicantId == applicantId;
  }

  @override
  int get hashCode {
    return nomineeName.hashCode ^
      addressLine1.hashCode ^
      addressLine2.hashCode ^
      landMark.hashCode ^
      city.hashCode ^
      taluka.hashCode ^
      district.hashCode ^
      state.hashCode ^
      country.hashCode ^
      pinCode.hashCode ^
      relationshipWithApplicant.hashCode ^
      dateOfBirth.hashCode ^
      age.hashCode ^
      applicantId.hashCode;
  }
}
