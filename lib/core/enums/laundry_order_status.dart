import 'package:flutter/material.dart';

enum LaundryOrderStatus {
  draft,
  pendingPayment,
  processing,
  completed,
  cancelled,
  paid,
}

extension LaundryOrderStatusExtension on LaundryOrderStatus {
  String get name {
    switch (this) {
      case LaundryOrderStatus.draft:
        return 'Nháp';
      case LaundryOrderStatus.pendingPayment:
        return 'Chờ thanh toán';
      case LaundryOrderStatus.processing:
        return 'Đang thực hiện';
      case LaundryOrderStatus.completed:
        return 'Hoàn thành';
      case LaundryOrderStatus.cancelled:
        return 'Đã hủy';
      case LaundryOrderStatus.paid:
        return 'Đã thanh toán';
    }
  }

  Color get color {
    switch (this) {
      case LaundryOrderStatus.draft:
        return Colors.grey[600]!; // Xám đậm
      case LaundryOrderStatus.pendingPayment:
        return Colors.orange[600]!; // Cam đậm
      case LaundryOrderStatus.processing:
        return Colors.blue[600]!; // Xanh dương đậm
      case LaundryOrderStatus.completed:
        return Colors.green[600]!; // Xanh lá cây đậm
      case LaundryOrderStatus.cancelled:
        return Colors.red[600]!; // Đỏ đậm
      case LaundryOrderStatus.paid:
        return Colors.green[800]!; // Xanh lá cây đậm hơn
    }
  }

  // Thêm phương thức từ chuỗi string
  static LaundryOrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return LaundryOrderStatus.draft;
      case 'pendingpayment':
        return LaundryOrderStatus.pendingPayment;
      case 'processing':
        return LaundryOrderStatus.processing;
      case 'completed':
        return LaundryOrderStatus.completed;
      case 'cancelled':
        return LaundryOrderStatus.cancelled;
      case 'paid':
        return LaundryOrderStatus.paid;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }
}
