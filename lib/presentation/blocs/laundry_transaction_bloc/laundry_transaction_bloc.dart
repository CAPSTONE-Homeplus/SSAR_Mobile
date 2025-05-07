import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';

import '../../../core/exception/exception_handler.dart';
import 'laundry_transaction_event.dart';
import 'laundry_transaction_state.dart';

class LaundryTransactionBloc
    extends Bloc<LaundryTransactionEvent, LaundryTransactionState> {
  final TransactionRepository transactionRepository;

  LaundryTransactionBloc({required this.transactionRepository})
      : super(LaundryTransactionState.initial()) {
    on<SaveLaundryTransactionEvent>(_onSaveLaundryTransaction);
  }

  void _onSaveLaundryTransaction(
      SaveLaundryTransactionEvent event,
      Emitter<LaundryTransactionState> emit,
      ) async {
    // Chuyển sang trạng thái loading
    emit(LaundryTransactionState.loading());

    try {
      // Thực hiện giao dịch
      final response = await transactionRepository.saveTransaction(event.transaction);

      // Chuyển sang trạng thái thành công
      emit(LaundryTransactionState.success(response));
    } catch (e) {
      // Xử lý ngoại lệ
      final errorMessage = _handleException(e);

      // Chuyển sang trạng thái thất bại
      emit(LaundryTransactionState.failure(errorMessage));
    }
  }

  // Phương thức riêng để xử lý ngoại lệ
  String _handleException(dynamic error) {
    if (error is ApiException) {
      return error.message ?? 'Có lỗi xảy ra khi thanh toán giặt';
    }

    return 'Có lỗi không xác định khi thanh toán giặt';
  }
}