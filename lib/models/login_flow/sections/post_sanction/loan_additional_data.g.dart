// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_additional_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanAdditionalDataDTO _$LoanAdditionalDataDTOFromJson(
        Map<String, dynamic> json) =>
    LoanAdditionalDataDTO(
      id: (json['id'] as num).toInt(),
      applicationId: (json['applicationId'] as num).toInt(),
      partnerId: (json['partnerId'] as num?)?.toInt(),
      partnerLoanId: (json['partnerLoanId'] as num?)?.toInt(),
      partnerDisbursementConfirmation:
          json['partnerDisbursementConfirmation'] as String?,
      kpclLoanApproval: json['kpclLoanApproval'] as String?,
      branchCode: json['branchCode'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      emiAmount: (json['emiAmount'] as num?)?.toDouble(),
      emiStartDate: json['emiStartDate'] == null
          ? null
          : DateTime.parse(json['emiStartDate'] as String),
      insurancePremiumAmount:
          (json['insurancePremiumAmount'] as num?)?.toDouble(),
      loanTenure: (json['loanTenure'] as num?)?.toInt(),
      totalEmiFromExistingLoans:
          (json['totalEmiFromExistingLoans'] as num?)?.toDouble(),
      requestedDisbursementDate: json['requestedDisbursementDate'] == null
          ? null
          : DateTime.parse(json['requestedDisbursementDate'] as String),
      bankAccountType: json['bankAccountType'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankName: json['bankName'] as String?,
      bankBranch: json['bankBranch'] as String?,
      ifscCode: json['ifscCode'] as String?,
      requestedLoanAmountForDisbursal:
          (json['requestedLoanAmountForDisbursal'] as num?)?.toDouble(),
      productCode: json['productCode'] as String?,
      nomineeInsuranceAmount:
          (json['nomineeInsuranceAmount'] as num?)?.toDouble(),
      agreementCharges: (json['agreementCharges'] as num?)?.toDouble(),
      emiProtectionCoverInsuranceAmount:
          (json['emiProtectionCoverInsuranceAmount'] as num?)?.toDouble(),
      hospitalCash: (json['hospitalCash'] as num?)?.toDouble(),
      renewalLoanInterestBalance:
          (json['renewalLoanInterestBalance'] as num?)?.toDouble(),
      renewalLoanPrincipalBalance:
          (json['renewalLoanPrincipalBalance'] as num?)?.toDouble(),
      beneficiaryType: json['beneficiaryType'] as String?,
      beneficiaryName: json['beneficiaryName'] as String?,
      beneficiaryAccountNumber: json['beneficiaryAccountNumber'] as String?,
      beneficiaryIfscCode: json['beneficiaryIfscCode'] as String?,
      beneficiaryMmid: json['beneficiaryMmid'] as String?,
      beneficiaryMobile: json['beneficiaryMobile'] as String?,
      rcNumber: json['rcNumber'] as String?,
      engineNumber: json['engineNumber'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      securityCheque1: json['securityCheque1'] as String?,
      securityCheque2: json['securityCheque2'] as String?,
      securityCheque3: json['securityCheque3'] as String?,
      securityCheque4: json['securityCheque4'] as String?,
      preSanction: json['preSanction'] as bool?,
      postSanctionSecurityCheck: json['postSanctionSecurityCheck'] as bool?,
      postDisbursement: json['postDisbursement'] as bool?,
    );

Map<String, dynamic> _$LoanAdditionalDataDTOToJson(
        LoanAdditionalDataDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applicationId': instance.applicationId,
      'partnerId': instance.partnerId,
      'partnerLoanId': instance.partnerLoanId,
      'partnerDisbursementConfirmation':
          instance.partnerDisbursementConfirmation,
      'kpclLoanApproval': instance.kpclLoanApproval,
      'branchCode': instance.branchCode,
      'rejectionReason': instance.rejectionReason,
      'emiAmount': instance.emiAmount,
      'emiStartDate': instance.emiStartDate?.toIso8601String(),
      'insurancePremiumAmount': instance.insurancePremiumAmount,
      'loanTenure': instance.loanTenure,
      'totalEmiFromExistingLoans': instance.totalEmiFromExistingLoans,
      'requestedDisbursementDate':
          instance.requestedDisbursementDate?.toIso8601String(),
      'bankAccountType': instance.bankAccountType,
      'bankAccountNumber': instance.bankAccountNumber,
      'bankName': instance.bankName,
      'bankBranch': instance.bankBranch,
      'ifscCode': instance.ifscCode,
      'requestedLoanAmountForDisbursal':
          instance.requestedLoanAmountForDisbursal,
      'productCode': instance.productCode,
      'nomineeInsuranceAmount': instance.nomineeInsuranceAmount,
      'agreementCharges': instance.agreementCharges,
      'emiProtectionCoverInsuranceAmount':
          instance.emiProtectionCoverInsuranceAmount,
      'hospitalCash': instance.hospitalCash,
      'renewalLoanInterestBalance': instance.renewalLoanInterestBalance,
      'renewalLoanPrincipalBalance': instance.renewalLoanPrincipalBalance,
      'beneficiaryType': instance.beneficiaryType,
      'beneficiaryName': instance.beneficiaryName,
      'beneficiaryAccountNumber': instance.beneficiaryAccountNumber,
      'beneficiaryIfscCode': instance.beneficiaryIfscCode,
      'beneficiaryMmid': instance.beneficiaryMmid,
      'beneficiaryMobile': instance.beneficiaryMobile,
      'rcNumber': instance.rcNumber,
      'engineNumber': instance.engineNumber,
      'chassisNumber': instance.chassisNumber,
      'securityCheque1': instance.securityCheque1,
      'securityCheque2': instance.securityCheque2,
      'securityCheque3': instance.securityCheque3,
      'securityCheque4': instance.securityCheque4,
      'preSanction': instance.preSanction,
      'postSanctionSecurityCheck': instance.postSanctionSecurityCheck,
      'postDisbursement': instance.postDisbursement,
    };
