import 'package:json_annotation/json_annotation.dart';

part 'repayment_schedule_dto.g.dart';

@JsonSerializable()
class RepaymentScheduleDTO {
  int id;
  int applicantId;
  int installmentNumber;
  double openingBalance;
  double closingBalance;
  double principleComponent;
  double interestComponent;
  DateTime startDate;
  double emiAmount;

  RepaymentScheduleDTO({
    required this.id,
    required this.applicantId,
    required this.installmentNumber,
    required this.openingBalance,
    required this.closingBalance,
    required this.principleComponent,
    required this.interestComponent,
    required this.startDate,
    required this.emiAmount,
  });

  factory RepaymentScheduleDTO.fromJson(Map<String, dynamic> json) => _$RepaymentScheduleDTOFromJson(json);
  Map<String, dynamic> toJson() => _$RepaymentScheduleDTOToJson(this);

}