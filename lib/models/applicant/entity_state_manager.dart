// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'entity_state_manager.g.dart';

@JsonSerializable()
class EntityStateManager {
  int id;
  String? entityType;
  String entityId;
  String applicationReferenceNum;
  String? stateCode;
  String? description;
  String status;
  String? errorData;
  String? field;
  String? dataError;
  String? actionRequired;
  String? reasonForRejection;
  String? documentRejectionReason;
  String? reviewerRemarks;

  EntityStateManager({
    required this.id,
    this.entityType,
    required this.entityId,
    required this.applicationReferenceNum,
    this.stateCode,
    this.description,
    required this.status,
    this.errorData,
    this.field,
    this.dataError,
    this.actionRequired,
    this.reasonForRejection,
    this.documentRejectionReason,
    this.reviewerRemarks,
  });

  factory EntityStateManager.fromJson(Map<String, dynamic> json) => _$EntityStateManagerFromJson(json);
  Map<String, dynamic> toJson() => _$EntityStateManagerToJson(this);

}
