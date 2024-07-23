class BranchDTO {
  String? id;
  int version;
  String code;
  String name;
  DateTime? branchOpenDate;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? district;
  String? state;
  String? country;
  int? pinCode;
  String? operationalStatus;
  DateTime? currentWorkingDate;
  String? gstin;
  String? weekendDay1;
  String? weekendDay2;

  BranchDTO({
    this.id,
    required this.version,
    required this.code,
    required this.name,
    this.branchOpenDate,
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pinCode,
    this.operationalStatus,
    this.currentWorkingDate,
    this.gstin,
    this.weekendDay1,
    this.weekendDay2,
  });

  factory BranchDTO.fromJson(Map<String, dynamic> json) {
    return BranchDTO(
      id: json['id'],
      version: json['version'],
      code: json['code'],
      name: json['name'],
      branchOpenDate: json['branchOpenDate'] != null ? DateTime.parse(json['branchOpenDate']) : null,
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      country: json['country'],
      pinCode: json['pinCode'],
      operationalStatus: json['operationalStatus'],
      currentWorkingDate: json['currentWorkingDate'] != null ? DateTime.parse(json['currentWorkingDate']) : null,
      gstin: json['gstin'],
      weekendDay1: json['weekendDay1'],
      weekendDay2: json['weekendDay2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'code': code,
      'name': name,
      'branchOpenDate': branchOpenDate?.toIso8601String(),
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'city': city,
      'district': district,
      'state': state,
      'country': country,
      'pinCode': pinCode,
      'operationalStatus': operationalStatus,
      'currentWorkingDate': currentWorkingDate?.toIso8601String(),
      'gstin': gstin,
      'weekendDay1': weekendDay1,
      'weekendDay2': weekendDay2,
    };
  }
}
