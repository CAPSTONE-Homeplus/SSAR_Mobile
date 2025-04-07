import 'package:flutter/material.dart';

enum TransactionStatus {
  pending,
  success,
  failed,
}

enum TransactionType {
  deposit,
  spending,
  refund,
}

extension TransactionStatusExtension on TransactionStatus {
  static TransactionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TransactionStatus.pending;
      case 'success':
        return TransactionStatus.success;
      case 'failed':
        return TransactionStatus.failed;
      default:
        throw ArgumentError('Invalid transaction status: $status');
    }
  }

  String get name {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  Color get color {
    switch (this) {
      case TransactionStatus.pending:
        return const Color(0xFFFFB700); // Màu vàng
      case TransactionStatus.success:
        return const Color(0xFF1CAF7D); // Màu xanh lá
      case TransactionStatus.failed:
        return const Color(0xFFFF3B3B); // Màu đỏ
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionStatus.pending:
        return Icons.pending_outlined;
      case TransactionStatus.success:
        return Icons.check_circle_outline;
      case TransactionStatus.failed:
        return Icons.error_outline;
    }
  }
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.deposit:
        return 'Nạp tiền';
      case TransactionType.spending:
        return 'Chi tiêu';
      case TransactionType.refund:
        return 'Hoàn tiền';
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.deposit:
        return Colors.green;
      case TransactionType.spending:
        return Colors.orange;
      case TransactionType.refund:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionType.deposit:
        return Icons.attach_money;
      case TransactionType.spending:
        return Icons.shopping_cart;
      case TransactionType.refund:
        return Icons.money_off;
    }
  }
}

extension TransactionTypeParser on String {
  TransactionType toTransactionType() {
    switch (toLowerCase()) {
      case 'deposit':
        return TransactionType.deposit;
      case 'refund':
        return TransactionType.refund;
      case 'spending':
        return TransactionType.spending;
      default:
       return TransactionType.spending; // Default case
    }
  }
}


