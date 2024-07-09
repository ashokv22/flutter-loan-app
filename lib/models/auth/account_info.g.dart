// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfoDTO _$AccountInfoDTOFromJson(Map<String, dynamic> json) =>
    AccountInfoDTO(
      id: (json['id'] as num?)?.toInt(),
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      authorities: (json['authorities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      userId: json['userId'] as String,
      contactNumber: json['contactNumber'] as String?,
      branchCode: json['branchCode'] as String?,
      branchData:
          BranchDataDTO.fromJson(json['branchData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountInfoDTOToJson(AccountInfoDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'roles': instance.roles,
      'authorities': instance.authorities,
      'userId': instance.userId,
      'contactNumber': instance.contactNumber,
      'branchCode': instance.branchCode,
      'branchData': instance.branchData,
    };

BranchDataDTO _$BranchDataDTOFromJson(Map<String, dynamic> json) =>
    BranchDataDTO(
      branch: json['branch'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$BranchDataDTOToJson(BranchDataDTO instance) =>
    <String, dynamic>{
      'branch': instance.branch,
      'city': instance.city,
      'state': instance.state,
    };
