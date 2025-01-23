import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/option_repository.dart';
import 'package:home_clean/presentation/blocs/option/option_event.dart';
import 'package:home_clean/presentation/blocs/option/option_state.dart';

class OptionBloc extends Bloc<OptionEvent, OptionState> {
  final OptionRepository optionRepository;

  OptionBloc({required this.optionRepository}) : super(OptionInitialState()) {
    on<GetOptionsEvent>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetOptionsEvent event,
    Emitter<OptionState> emit,
  ) async {
    emit(OptionLoadingState());
    try {
      final response = await optionRepository.getOptionsByServiceId(
        serviceId: event.serviceId,
      );
      emit(OptionSuccessState(options: response.items));
    } catch (e) {
      emit(OptionErrorState(message: e.toString()));
    }
  }
}
