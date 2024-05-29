import 'package:json_annotation/json_annotation.dart';

part 'application_reject_reason_history.g.dart';

@JsonSerializable()
class ApplicationRejectReasonHistory {
  int id;
  String? actionRequired;
  String? reasonForRejection;
  String? documentRejectionReason;
  String? reviewerRemarks;
  int submitId;
  DateTime historyDateTime;
  ApplicationRejectReasonHistory({
    required this.id,
    this.actionRequired,
    this.reasonForRejection,
    this.documentRejectionReason,
    this.reviewerRemarks,
    required this.submitId,
    required this.historyDateTime,
  });

  
  factory ApplicationRejectReasonHistory.fromJson(Map<String, dynamic> json) => _$ApplicationRejectReasonHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationRejectReasonHistoryToJson(this);
}
