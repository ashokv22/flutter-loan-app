// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_pending_products_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPendingProductsDTO _$LoginPendingProductsDTOFromJson(
        Map<String, dynamic> json) =>
    LoginPendingProductsDTO(
      id: json['id'] as int,
      product: json['product'] as String,
      loanAmount: (json['loanAmount'] as num).toDouble(),
      applicants: (json['applicants'] as List<dynamic>)
          .map((e) => Individual.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LoginPendingProductsDTOToJson(
        LoginPendingProductsDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'loanAmount': instance.loanAmount,
      'applicants': instance.applicants,
    };
