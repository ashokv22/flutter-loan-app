// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitee_urls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteeUrls _$InviteeUrlsFromJson(Map<String, dynamic> json) => InviteeUrls(
      customerType: json['customerType'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      url: json['url'] as String?,
      signed: json['signed'] as bool?,
    );

Map<String, dynamic> _$InviteeUrlsToJson(InviteeUrls instance) =>
    <String, dynamic>{
      'customerType': instance.customerType,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'url': instance.url,
      'signed': instance.signed,
    };
