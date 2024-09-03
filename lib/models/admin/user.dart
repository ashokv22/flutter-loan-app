import 'package:json_annotation/json_annotation.dart';
import 'package:origination/models/admin/branch/branch_dto.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  int? version;
  String login;
  String passwordHash;
  String firstName;
  String? middleName;
  String lastName;
  String emailAddress;
  String? imageUrl;
  bool activated;
  String? langKey;
  String? role;
  String? branchCode;
  String? branchSetCode;
  String? activationKey;
  String? resetKey;
  String? hrmsId;
  String? salutation;
  DateTime? hrmsUpdatedOn;
  String? smName;
  String? smHrmsId;
  String? stateHeadName;
  String? stateHeadHrmsId;
  List<String>? authorities;
  BranchDTO? branchDTO;
  User({
    this.id,
    this.version,
    required this.login,
    required this.passwordHash,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.emailAddress,
    this.imageUrl,
    required this.activated,
    this.langKey,
    this.role,
    this.branchCode,
    this.branchSetCode,
    this.activationKey,
    this.resetKey,
    this.hrmsId,
    this.salutation,
    this.hrmsUpdatedOn,
    this.smName,
    this.smHrmsId,
    this.stateHeadName,
    this.stateHeadHrmsId,
    this.authorities,
    this.branchDTO,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}
