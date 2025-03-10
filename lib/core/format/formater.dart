import 'package:intl/intl.dart';

class Formater {
  static String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(amount);
  }

  static String formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatAmount(String? amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(
        locale: 'vi_VN', symbol: '₫');

    if (amount == null || amount.isEmpty) return '0₫';
    try {
      final double amountValue = double.parse(amount);
      return currencyFormat.format(amountValue);
    } catch (e) {
      return amount;
    }
  }

  static String parseStatusToString(String status) {
    switch (status.toLowerCase()) {
      case 'failed':
        return 'THẤT BẠI';
      case 'pending':
        return 'ĐANG XỬ LÝ';
      case 'success':
        return 'THÀNH CÔNG'; // Nếu cần
      default:
        return status.toUpperCase(); // Giữ nguyên nếu không khớp
    }
  }

  static String formatInviteWalletMessage(Map<String, dynamic> data) {
    String ownerId = data['ownerId']?.toString() ?? 'Không xác định';
    String memberId = data['memberId']?.toString() ?? 'Không xác định';
    String walletId = data['walletId']?.toString() ?? 'Không xác định';
    return '$ownerId đã mời bạn tham gia ví chung $walletId.';
  }

  static String formatActivityStatusMessage(Map<String, dynamic> data) {
    List<dynamic> activities = data['activities'] as List<dynamic>? ?? [];
    if (activities.isEmpty) {
      return 'Không có hoạt động nào được cập nhật.';
    }

    StringBuffer message = StringBuffer('Cập nhật trạng thái hoạt động:\n');
    for (var activity in activities) {
      String activityId = activity['activityId'] ?? 'Không xác định';
      String status = activity['status'] ?? 'không rõ trạng thái';
      message.writeln('- Hoạt động $activityId: $status');
    }
    return message.toString().trim();
  }
}
