import 'package:intl/intl.dart';

class LoanAmountFormatter {
  static final formatter = NumberFormat.decimalPattern();

  static String transform(double loanAmount) {
    if (loanAmount >= 10000000) {
      final croreAmount = loanAmount / 10000000;
      return '${formatter.format(croreAmount)}Cr';
    } else if (loanAmount >= 100000) {
      final lakhAmount = loanAmount / 100000;
      return '${formatter.format(lakhAmount)}L';
    } else {
      return formatter.format(loanAmount);
    }
  }
}
