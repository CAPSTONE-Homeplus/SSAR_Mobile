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
        return 'Đang chờ xử lí';
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

  String get statusName {
    switch (this) {
      case LaundryOrderStatus.draft:
        return 'draft';
      case LaundryOrderStatus.pendingPayment:
        return 'pendingPayment';
      case LaundryOrderStatus.processing:
        return 'processing';
      case LaundryOrderStatus.completed:
        return 'completed';
      case LaundryOrderStatus.cancelled:
        return 'cancelled';
      case LaundryOrderStatus.paid:
        return 'paid';
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

enum TaskStatusEnum { Pending, InProgress, Completed, Canceled }

extension TaskStatusEnumExtension on TaskStatusEnum {
  static TaskStatusEnum fromString(String value) {
    switch (value) {
      case 'Pending':
        return TaskStatusEnum.Pending;
      case 'InProgress':
        return TaskStatusEnum.InProgress;
      case 'Completed':
        return TaskStatusEnum.Completed;
      case 'Canceled':
        return TaskStatusEnum.Canceled;
      default:
        throw ArgumentError(
            'Không thể chuyển đổi "$value" thành TaskStatusEnum');
    }
  }

  String get name => switch (this) {
        TaskStatusEnum.Pending => 'Chờ xử lý',
        TaskStatusEnum.InProgress => 'Đang thực hiện',
        TaskStatusEnum.Completed => 'Hoàn thành',
        TaskStatusEnum.Canceled => 'Đã hủy',
      };

  Color get color => switch (this) {
        TaskStatusEnum.Pending => Colors.orange.shade600,
        TaskStatusEnum.InProgress => Colors.blue.shade600,
        TaskStatusEnum.Completed => Colors.green.shade600,
        TaskStatusEnum.Canceled => Colors.red.shade600,
      };

  IconData get iconData => switch (this) {
        TaskStatusEnum.Pending => Icons.pending,
        TaskStatusEnum.InProgress => Icons.hourglass_empty,
        TaskStatusEnum.Completed => Icons.check_circle,
        TaskStatusEnum.Canceled => Icons.cancel,
      };

  Widget get iconWidget => Icon(iconData, color: color);
}
