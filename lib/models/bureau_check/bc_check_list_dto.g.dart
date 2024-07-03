// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bc_check_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckListDTO _$CheckListDTOFromJson(Map<String, dynamic> json) => CheckListDTO(
      id: (json['id'] as num).toInt(),
      type: $enumDecode(_$CibilTypeEnumMap, json['type']),
      name: json['name'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$CheckListDTOToJson(CheckListDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$CibilTypeEnumMap[instance.type]!,
      'name': instance.name,
      'status': instance.status,
    };

const _$CibilTypeEnumMap = {
  CibilType.APPLICANT: 'APPLICANT',
  CibilType.CO_APPLICANT: 'CO_APPLICANT',
  CibilType.GUARANTOR: 'GUARANTOR',
  CibilType.COMMERCIAL: 'COMMERCIAL',
};
