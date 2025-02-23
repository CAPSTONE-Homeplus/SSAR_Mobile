import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/use_cases/payment_method/get_payment_methods_use_case.dart';
import 'package:home_clean/presentation/blocs/payment_method/payment_method_event.dart';
import 'package:home_clean/presentation/blocs/payment_method/payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;

  PaymentMethodBloc(this._getPaymentMethodsUseCase) : super(PaymentMethodInitial()) {
    on<GetPaymentMethodsEvent>(_onGetPaymentMethods);
  }

  Future<void> _onGetPaymentMethods(
      GetPaymentMethodsEvent event, Emitter<PaymentMethodState> emit) async {
    emit(PaymentMethodLoading());

    final result = await _getPaymentMethodsUseCase.execute(
      event.search,
      event.orderBy,
      event.page,
      event.size,
    );

    result.fold(
          (failure) => emit(PaymentMethodError(failure.message)),
          (methods) => emit(PaymentMethodLoaded(methods)),
    );
  }
}
