import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/blocs/cleaning_transaction_bloc/cleaning_transaction_event.dart';
import 'package:home_clean/presentation/blocs/cleaning_transaction_bloc/cleaning_transaction_state.dart';

import '../../../domain/repositories/transaction_repository.dart';

class CleaningTransactionBloc
    extends Bloc<CleaningTransactionEvent, CleaningTransactionState> {
  final TransactionRepository transactionRepository;

  CleaningTransactionBloc(this.transactionRepository)
      : super(CleaningTransactionState()) {
    on<SaveCleaningTransactionEvent>((event, emit) async {
      emit(state.copyWith(status: CleaningTransactionStatus.loading));
      try {
        final response = await transactionRepository.saveTransaction(event.transaction);
        emit(state.copyWith(
            status: CleaningTransactionStatus.success,
            data: response
        ));
      } catch (e) {
        emit(state.copyWith(
            status: CleaningTransactionStatus.failure,
            errorMessage: "Có lỗi xảy ra khi thanh toán dọn dẹp"
        ));
      }
    });
  }
}