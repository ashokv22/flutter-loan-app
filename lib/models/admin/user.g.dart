// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      version: (json['version'] as num?)?.toInt(),
      login: json['login'] as String,
      passwordHash: json['passwordHash'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      emailAddress: json['emailAddress'] as String,
      imageUrl: json['imageUrl'] as String?,
      activated: json['activated'] as bool,
      langKey: json['langKey'] as String?,
      role: json['role'] as String?,
      branchCode: json['branchCode'] as String?,
      branchSetCode: json['branchSetCode'] as String?,
      hrmsId: json['hrmsId'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'login': instance.login,
      'passwordHash': instance.passwordHash,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'emailAddress': instance.emailAddress,
      'imageUrl': instance.imageUrl,
      'activated': instance.activated,
      'langKey': instance.langKey,
      'role': instance.role,
      'branchCode': instance.branchCode,
      'branchSetCode': instance.branchSetCode,
      'hrmsId': instance.hrmsId,
    };
