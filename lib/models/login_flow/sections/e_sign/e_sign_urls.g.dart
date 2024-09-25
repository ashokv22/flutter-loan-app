// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_sign_urls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ESignUrls _$ESignUrlsFromJson(Map<String, dynamic> json) => ESignUrls(
      documentType: json['documentType'] as String?,
      status: json['status'] as String?,
      customerType: json['customerType'] as String?,
      inviteeUrls: (json['inviteeUrls'] as List<dynamic>?)
          ?.map((e) => InviteeUrls.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ESignUrlsToJson(ESignUrls instance) => <String, dynamic>{
      'documentType': instance.documentType,
      'status': instance.status,
      'customerType': instance.customerType,
      'inviteeUrls': instance.inviteeUrls,
    };
