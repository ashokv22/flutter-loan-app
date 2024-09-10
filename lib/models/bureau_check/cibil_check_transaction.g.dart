// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cibil_check_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CibilCheckTransactionDTO _$CibilCheckTransactionDTOFromJson(
        Map<String, dynamic> json) =>
    CibilCheckTransactionDTO(
      id: (json['id'] as num).toInt(),
      version: (json['version'] as num?)?.toInt(),
      cibilId: (json['cibilId'] as num).toInt(),
      individualId: (json['individualId'] as num?)?.toInt(),
      cibilType: $enumDecodeNullable(_$CibilTypeEnumMap, json['cibilType']),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      transactionDetails: json['transactionDetails'] as String?,
      cibilScore: (json['cibilScore'] as num?)?.toInt(),
      requestId: json['requestId'] as String?,
      cibilResponse: json['cibilResponse'] as String?,
      fileId: (json['fileId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CibilCheckTransactionDTOToJson(
        CibilCheckTransactionDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'cibilId': instance.cibilId,
      'individualId': instance.individualId,
      'cibilType': _$CibilTypeEnumMap[instance.cibilType],
      'dateTime': instance.dateTime?.toIso8601String(),
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'transactionDetails': instance.transactionDetails,
      'cibilScore': instance.cibilScore,
      'requestId': instance.requestId,
      'cibilResponse': instance.cibilResponse,
      'fileId': instance.fileId,
    };

const _$CibilTypeEnumMap = {
  CibilType.INDIVIDUAL_CIBIL: 'INDIVIDUAL_CIBIL',
  CibilType.COMMERCIAL_CIBIL: 'COMMERCIAL_CIBIL',
};

const _$TransactionTypeEnumMap = {
  TransactionType.REQUESTED: 'REQUESTED',
  TransactionType.GENERATED: 'GENERATED',
  TransactionType.APPROVED: 'APPROVED',
  TransactionType.REJECTED: 'REJECTED',
};
