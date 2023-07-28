import 'package:intl/intl.dart';

class LoanAmountFormatter {
  static final formatter = NumberFormat.decimalPattern();

  static String transform(double loanAmount) {
    if (loanAmount >= 10000000) {
      final croreAmount = loanAmount / 10000000;
      return '${_getFormattedAmount(croreAmount)}Cr';
    } else if (loanAmount >= 100000) {
      final lakhAmount = loanAmount / 100000;
      return '${_getFormattedAmount(lakhAmount)}L';
    } else {
      return _getFormattedAmount(loanAmount);
    }
  }

  static String _getFormattedAmount(double amount) {
    // Use a custom NumberFormat with one decimal place
    final customFormatter = NumberFormat('###,##0.0');
    return customFormatter.format(amount);
  }
}
