import 'package:flutter/material.dart';

enum OrderStatus {
  draft,
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
  scheduled
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.draft:
        return 'Nháp';
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.accepted:
        return 'Đã tiếp nhận';
      case OrderStatus.inProgress:
        return 'Đang thực hiện';
      case OrderStatus.completed:
        return 'Hoàn thành';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      case OrderStatus.scheduled:
        return 'Đã lên lịch';
    }
  }


  Color get chipColor {
    switch (this) {
      case OrderStatus.draft:
        return Colors.grey[200]!;
      case OrderStatus.pending:
        return Colors.orange[100]!;
      case OrderStatus.accepted:
        return Colors.blue[100]!;
      case OrderStatus.inProgress:
        return Colors.blue[100]!;
      case OrderStatus.completed:
        return Colors.green[100]!;
      case OrderStatus.cancelled:
        return Colors.red[100]!;
      case OrderStatus.scheduled:
        return Colors.purple[100]!;
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.draft:
        return Colors.grey[800]!;
      case OrderStatus.pending:
        return Colors.orange[800]!;
      case OrderStatus.accepted:
        return Colors.blue[800]!;
      case OrderStatus.inProgress:
        return Colors.blue[800]!;
      case OrderStatus.completed:
        return Colors.green[800]!;
      case OrderStatus.cancelled:
        return Colors.red[800]!;
      case OrderStatus.scheduled:
        return Colors.purple[800]!;
    }
  }
}

extension StringToOrderStatus on String {
  OrderStatus toOrderStatus() {
    switch (toLowerCase()) {
      case 'draft':
        return OrderStatus.draft;
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'inprogress':
        return OrderStatus.inProgress;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'scheduled':
        return OrderStatus.scheduled;
      default:
        return OrderStatus.draft; // Giá trị mặc định
    }
  }
}
