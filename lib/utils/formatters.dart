import 'package:intl/intl.dart';

class Formatters {
  static String currency(double amount) {
    return NumberFormat.currency(symbol: '\RS.', decimalDigits: 2)
        .format(amount);
  }

  static String date(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String monthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String shortDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
}
