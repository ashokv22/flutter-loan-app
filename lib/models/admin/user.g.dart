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
      activationKey: json['activationKey'] as String?,
      resetKey: json['resetKey'] as String?,
      hrmsId: json['hrmsId'] as String?,
      salutation: json['salutation'] as String?,
      hrmsUpdatedOn: json['hrmsUpdatedOn'] == null
          ? null
          : DateTime.parse(json['hrmsUpdatedOn'] as String),
      smName: json['smName'] as String?,
      smHrmsId: json['smHrmsId'] as String?,
      stateHeadName: json['stateHeadName'] as String?,
      stateHeadHrmsId: json['stateHeadHrmsId'] as String?,
      authorities: (json['authorities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      branchDTO: json['branchDTO'] == null
          ? null
          : BranchDTO.fromJson(json['branchDTO'] as Map<String, dynamic>),
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
      'activationKey': instance.activationKey,
      'resetKey': instance.resetKey,
      'hrmsId': instance.hrmsId,
      'salutation': instance.salutation,
      'hrmsUpdatedOn': instance.hrmsUpdatedOn?.toIso8601String(),
      'smName': instance.smName,
      'smHrmsId': instance.smHrmsId,
      'stateHeadName': instance.stateHeadName,
      'stateHeadHrmsId': instance.stateHeadHrmsId,
      'authorities': instance.authorities,
      'branchDTO': instance.branchDTO,
    };
