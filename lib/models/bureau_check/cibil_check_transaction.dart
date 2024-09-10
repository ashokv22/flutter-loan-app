import 'package:json_annotation/json_annotation.dart';

part 'cibil_check_transaction.g.dart';

@JsonSerializable()
class CibilCheckTransactionDTO {
  int id;
  int? version;
  int cibilId;
  int? individualId;
  CibilType? cibilType;
  DateTime? dateTime;
  TransactionType transactionType;
  String? transactionDetails;
  int? cibilScore;
  String? requestId;
  String? cibilResponse;
  int? fileId;

  CibilCheckTransactionDTO({
    required this.id,
    this.version,
    required this.cibilId,
    this.individualId,
    required this.cibilType,
    this.dateTime,
    required this.transactionType,
    this.transactionDetails,
    this.cibilScore,
    this.requestId,
    this.cibilResponse,
    this.fileId,
  });

  factory CibilCheckTransactionDTO.fromJson(Map<String, dynamic> json) => _$CibilCheckTransactionDTOFromJson(json);
  Map<String, dynamic> toJson() => _$CibilCheckTransactionDTOToJson(this);
}

enum CibilType {
  INDIVIDUAL_CIBIL,
  COMMERCIAL_CIBIL;
}

enum TransactionType {
  REQUESTED,
  GENERATED,
  APPROVED,
  REJECTED;
}
