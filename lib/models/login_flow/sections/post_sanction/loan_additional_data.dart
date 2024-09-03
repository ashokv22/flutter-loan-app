import 'package:json_annotation/json_annotation.dart';

part 'loan_additional_data.g.dart';

@JsonSerializable()
class LoanAdditionalDataDTO {
  int id;
  int applicationId;
  int? partnerId;
  int? partnerLoanId;
  String? partnerDisbursementConfirmation;
  String? kpclLoanApproval;
  String? branchCode;
  String? rejectionReason;
  double? emiAmount;
  DateTime? emiStartDate;
  double? insurancePremiumAmount;
  int? loanTenure;
  double? totalEmiFromExistingLoans;
  DateTime? requestedDisbursementDate;
  String? bankAccountType;
  String? bankAccountNumber;
  String? bankName;
  String? bankBranch;
  String? ifscCode;
  double? requestedLoanAmountForDisbursal;
  String? productCode;
  double? nomineeInsuranceAmount;
  double? agreementCharges;
  double? emiProtectionCoverInsuranceAmount;
  double? hospitalCash;
  double? renewalLoanInterestBalance;
  double? renewalLoanPrincipalBalance;
  String? beneficiaryType;
  String? beneficiaryName;
  String? beneficiaryAccountNumber;
  String? beneficiaryIfscCode;
  String? beneficiaryMmid;
  String? beneficiaryMobile;
  String? rcNumber;
  String? engineNumber;
  String? chassisNumber;
  String? securityCheque1;
  String? securityCheque2;
  String? securityCheque3;
  String? securityCheque4;
  bool? preSanction;
  bool? postSanctionSecurityCheck;
  bool? postDisbursement;

  LoanAdditionalDataDTO({
    required this.id,
    required this.applicationId,
    this.partnerId,
    this.partnerLoanId,
    this.partnerDisbursementConfirmation,
    this.kpclLoanApproval,
    this.branchCode,
    this.rejectionReason,
    this.emiAmount,
    this.emiStartDate,
    this.insurancePremiumAmount,
    this.loanTenure,
    this.totalEmiFromExistingLoans,
    this.requestedDisbursementDate,
    this.bankAccountType,
    this.bankAccountNumber,
    this.bankName,
    this.bankBranch,
    this.ifscCode,
    this.requestedLoanAmountForDisbursal,
    this.productCode,
    this.nomineeInsuranceAmount,
    this.agreementCharges,
    this.emiProtectionCoverInsuranceAmount,
    this.hospitalCash,
    this.renewalLoanInterestBalance,
    this.renewalLoanPrincipalBalance,
    this.beneficiaryType,
    this.beneficiaryName,
    this.beneficiaryAccountNumber,
    this.beneficiaryIfscCode,
    this.beneficiaryMmid,
    this.beneficiaryMobile,
    this.rcNumber,
    this.engineNumber,
    this.chassisNumber,
    this.securityCheque1,
    this.securityCheque2,
    this.securityCheque3,
    this.securityCheque4,
    this.preSanction,
    this.postSanctionSecurityCheck,
    this.postDisbursement,
  });

  
  factory LoanAdditionalDataDTO.fromJson(Map<String, dynamic> json) => _$LoanAdditionalDataDTOFromJson(json);
  Map<String, dynamic> toJson() => _$LoanAdditionalDataDTOToJson(this);

}

enum ADRAdditionalType {
  PRE_SANCTION, POST_DISBURSEMENT, POST_SANCTION_SECURITY_CHECK, POST_E_SIGN
}