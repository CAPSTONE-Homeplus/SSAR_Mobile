import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant.dart';
import 'package:home_clean/domain/use_cases/option/get_options_usecase.dart';
import 'package:home_clean/presentation/blocs/option/option_event.dart';
import 'package:home_clean/presentation/blocs/option/option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState> {
  final GetOptionsUsecase getOptionsUsecase;

  OptionBloc({required this.getOptionsUsecase}) : super(OptionInitialState()) {
    on<GetOptionsEvent>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetOptionsEvent event,
    Emitter<OptionState> emit,
  ) async {
    emit(OptionLoadingState());
    try {
      final response = await getOptionsUsecase.execute(
        event.serviceId,
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );
      emit(OptionSuccessState(options: response.items));
    } catch (e) {
      emit(OptionErrorState(message: e.toString()));
    }
  }
}
