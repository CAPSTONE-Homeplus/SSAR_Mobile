import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/constant.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_event.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_state.dart';

import '../../../domain/use_cases/extra_service/get_extra_service_use_case.dart';

class ExtraServiceBloc extends Bloc<ExtraServiceEvent, ExtraServiceState> {
  final GetExtraServiceUseCase getExtraServiceUseCase;

  ExtraServiceBloc({required this.getExtraServiceUseCase})
      : super(ExtraServiceInitialState()) {
    on<GetExtraServices>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetExtraServices event,
    Emitter<ExtraServiceState> emit,
  ) async {
    emit(ExtraServiceLoadingState());
    try {
      final response = await getExtraServiceUseCase.execute(
        event.serviceId,
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      emit(ExtraServiceSuccessState(extraServices: response.items));
    } catch (e) {
      emit(ExtraServiceErrorState(message: e.toString()));
    }
  }
}
