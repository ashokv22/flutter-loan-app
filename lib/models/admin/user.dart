import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String login;
  String firstName;
  String lastName;
  String emailAddress;
  String? imageUrl;
  bool activated;
  String? langKey;
  String? role;
  String? branchCode;
  String? branchSetCode;
  User({
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    this.imageUrl,
    required this.activated,
    this.langKey,
    this.role,
    this.branchCode,
    this.branchSetCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}
