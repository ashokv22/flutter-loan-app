// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepaymentScheduleDTO _$RepaymentScheduleDTOFromJson(
        Map<String, dynamic> json) =>
    RepaymentScheduleDTO(
      id: (json['id'] as num).toInt(),
      applicantId: (json['applicantId'] as num).toInt(),
      installmentNumber: (json['installmentNumber'] as num).toInt(),
      openingBalance: (json['openingBalance'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
      principleComponent: (json['principleComponent'] as num).toDouble(),
      interestComponent: (json['interestComponent'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      emiAmount: (json['emiAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$RepaymentScheduleDTOToJson(
        RepaymentScheduleDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applicantId': instance.applicantId,
      'installmentNumber': instance.installmentNumber,
      'openingBalance': instance.openingBalance,
      'closingBalance': instance.closingBalance,
      'principleComponent': instance.principleComponent,
      'interestComponent': instance.interestComponent,
      'startDate': instance.startDate.toIso8601String(),
      'emiAmount': instance.emiAmount,
    };
