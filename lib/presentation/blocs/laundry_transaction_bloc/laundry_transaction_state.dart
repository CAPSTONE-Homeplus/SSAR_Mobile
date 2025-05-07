import 'package:equatable/equatable.dart';
import 'package:home_clean/domain/entities/transaction/transaction.dart';

enum LaundryTransactionStatus {
  initial,
  loading,
  success,
  failure,
}

class LaundryTransactionState extends Equatable {
  final LaundryTransactionStatus status;
  final Transaction? data;
  final String? errorMessage;

  const LaundryTransactionState({
    this.status = LaundryTransactionStatus.initial,
    this.data,
    this.errorMessage,
  });

  // Factory constructor để tạo các trạng thái cụ thể
  factory LaundryTransactionState.initial() =>
      const LaundryTransactionState();

  factory LaundryTransactionState.loading() =>
      const LaundryTransactionState(status: LaundryTransactionStatus.loading);

  factory LaundryTransactionState.success(Transaction transaction) =>
      LaundryTransactionState(
          status: LaundryTransactionStatus.success,
          data: transaction
      );

  factory LaundryTransactionState.failure(String error) =>
      LaundryTransactionState(
          status: LaundryTransactionStatus.failure,
          errorMessage: error
      );

  // Phương thức copyWith để dễ dàng tạo bản sao với các thay đổi
  LaundryTransactionState copyWith({
    LaundryTransactionStatus? status,
    Transaction? data,
    String? errorMessage,
  }) {
    return LaundryTransactionState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Implement Equatable
  @override
  List<Object?> get props => [status, data, errorMessage];
}