enum CleaningTransactionStatus { initial, loading, success, failure }

class CleaningTransactionState {
  final CleaningTransactionStatus status;
  final dynamic data;
  final String? errorMessage;

  CleaningTransactionState({
    this.status = CleaningTransactionStatus.initial,
    this.data,
    this.errorMessage,
  });

  CleaningTransactionState copyWith({
    CleaningTransactionStatus? status,
    dynamic data,
    String? errorMessage,
  }) {
    return CleaningTransactionState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}