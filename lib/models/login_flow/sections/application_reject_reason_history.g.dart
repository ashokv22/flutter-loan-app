// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_reject_reason_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationRejectReasonHistory _$ApplicationRejectReasonHistoryFromJson(
        Map<String, dynamic> json) =>
    ApplicationRejectReasonHistory(
      id: (json['id'] as num).toInt(),
      actionRequired: json['actionRequired'] as String?,
      reasonForRejection: json['reasonForRejection'] as String?,
      documentRejectionReason: json['documentRejectionReason'] as String?,
      reviewerRemarks: json['reviewerRemarks'] as String?,
      submitId: (json['submitId'] as num).toInt(),
      historyDateTime: DateTime.parse(json['historyDateTime'] as String),
    );

Map<String, dynamic> _$ApplicationRejectReasonHistoryToJson(
        ApplicationRejectReasonHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actionRequired': instance.actionRequired,
      'reasonForRejection': instance.reasonForRejection,
      'documentRejectionReason': instance.documentRejectionReason,
      'reviewerRemarks': instance.reviewerRemarks,
      'submitId': instance.submitId,
      'historyDateTime': instance.historyDateTime.toIso8601String(),
    };
