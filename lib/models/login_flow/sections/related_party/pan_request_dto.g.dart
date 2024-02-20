// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanRequestDTO _$PanRequestDTOFromJson(Map<String, dynamic> json) =>
    PanRequestDTO(
      id: json['id'] as String?,
      panNo: json['panNo'] as String,
      exist: json['exist'] as String,
      title: json['title'] as String?,
      issueDate: json['issueDate'] as String,
      firstname: json['firstname'] as String,
      middlename: json['middlename'] as String?,
      lastname: json['lastname'] as String,
    );

Map<String, dynamic> _$PanRequestDTOToJson(PanRequestDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'panNo': instance.panNo,
      'exist': instance.exist,
      'title': instance.title,
      'issueDate': instance.issueDate,
      'firstname': instance.firstname,
      'middlename': instance.middlename,
      'lastname': instance.lastname,
    };
