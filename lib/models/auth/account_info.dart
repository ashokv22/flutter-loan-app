import 'package:json_annotation/json_annotation.dart';

part 'account_info.g.dart';

@JsonSerializable()
class AccountInfoDTO {
  int? id;
  String username;
  String name;
  String email;
  List<String>? roles;
  List<String>? authorities;
  String userId;
  String? contactNumber;
  String? branchCode;
  BranchDataDTO branchData;

  AccountInfoDTO({
    this.id,
    required this.username,
    required this.name,
    required this.email,
    this.roles,
    this.authorities,
    required this.userId,
    this.contactNumber,
    this.branchCode,
    required this.branchData,

  });

  factory AccountInfoDTO.fromJson(Map<String, dynamic> json) => _$AccountInfoDTOFromJson(json);
  Map<String, dynamic> toJson() => _$AccountInfoDTOToJson(this);
}

@JsonSerializable()
class BranchDataDTO {
  String? branch;
  String? city;
  String? state;
  BranchDataDTO ({
    this.branch,
    this.city,
    this.state,
  });
  
  factory BranchDataDTO.fromJson(Map<String, dynamic> json) => _$BranchDataDTOFromJson(json);
  Map<String, dynamic> toJson() => _$BranchDataDTOToJson(this);
}