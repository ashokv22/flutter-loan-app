// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leads_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeadsListDTO _$LeadsListDTOFromJson(Map<String, dynamic> json) => LeadsListDTO(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: json['status'] as String,
      dsaName: json['dsaName'] as String?,
      model: json['model'] as String,
      mobile: json['mobile'] as String,
      applicantId: json['applicantId'] as String,
      loanAmount: (json['loanAmount'] as num?)?.toDouble(),
      createdDate: DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$LeadsListDTOToJson(LeadsListDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'dsaName': instance.dsaName,
      'model': instance.model,
      'mobile': instance.mobile,
      'applicantId': instance.applicantId,
      'loanAmount': instance.loanAmount,
      'createdDate': instance.createdDate.toIso8601String(),
    };
