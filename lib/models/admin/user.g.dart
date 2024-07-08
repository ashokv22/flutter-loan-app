// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      login: json['login'] as String,
      firstName: json['firstName'] as String,
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
      'login': instance.login,
      'firstName': instance.firstName,
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
