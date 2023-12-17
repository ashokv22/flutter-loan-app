// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDTO _$AddressDTOFromJson(Map<String, dynamic> json) => AddressDTO(
      city: json['city'] as String?,
      country: json['country'] as String?,
      district: json['district'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$AddressDTOToJson(AddressDTO instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'district': instance.district,
      'state': instance.state,
    };
