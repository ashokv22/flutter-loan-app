class ApplicantSearchSpecification {
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? mobile;
  String? ownedBy;
  String? branch;

  ApplicantSearchSpecification({
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.mobile,
    this.ownedBy,
    this.branch,
  });

  factory ApplicantSearchSpecification.fromJson(Map<String, dynamic> json) {
    return ApplicantSearchSpecification(
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      gender: json['gender'],
      mobile: json['mobile'],
      ownedBy: json['ownedBy'],
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'gender': gender,
      'mobile': mobile,
      'ownedBy': ownedBy,
      'branch': branch,
    };
  }
}
