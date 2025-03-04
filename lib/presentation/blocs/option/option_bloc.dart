import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/constants.dart';
import 'package:home_clean/domain/use_cases/option/get_options_use_case.dart';
import 'package:home_clean/presentation/blocs/option/option_event.dart';
import 'package:home_clean/presentation/blocs/option/option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState> {
  final GetOptionsUseCase getOptionsUseCase;

  OptionBloc({required this.getOptionsUseCase}) : super(OptionInitialState()) {
    on<GetOptionsEvent>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetOptionsEvent event,
    Emitter<OptionState> emit,
  ) async {
    emit(OptionLoadingState());
    try {
      final response = await getOptionsUseCase.execute(
        event.serviceId,
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );
      emit(OptionSuccessState(options: response.items));
    } catch (e) {
      emit(OptionErrorState(message: e.toString()));
    }
  }
}
