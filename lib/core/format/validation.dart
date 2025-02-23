import 'package:intl/intl.dart';

class Validation {
  static String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount);
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }
}
