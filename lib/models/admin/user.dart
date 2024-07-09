import 'package:json_annotation/json_annotation.dart';

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
  String? hrmsId;
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
    this.hrmsId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}
