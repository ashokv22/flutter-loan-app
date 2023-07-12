class FlowableApplicationDto {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;
  final String address;
  final int loanAmount;

  FlowableApplicationDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.loanAmount,
  });

  factory FlowableApplicationDto.fromJson(Map<String, dynamic> json) {
    return FlowableApplicationDto(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      loanAmount: json['loanAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'address': address,
      'loanAmount': loanAmount,
    };
  }
}
