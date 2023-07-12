class UserCompositeDTO {
  final String oldPassword;
  final String newPassword;
  final String key;

  UserCompositeDTO({
    required this.oldPassword,
    required this.newPassword,
    required this.key
  });

  factory UserCompositeDTO.fromJson(Map<String, dynamic> json) {
    return UserCompositeDTO(
      oldPassword: json['oldPassword'],
      newPassword: json['newPassword'],
      key: json['key']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'key': key
    };
  }
}