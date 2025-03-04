import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_event.dart';
import 'package:home_clean/presentation/blocs/extra_service/extra_service_state.dart';

import '../../../core/constant/constants.dart';
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
    final response = await getExtraServiceUseCase.execute(
        event.serviceId,
        event.search,
        event.orderBy,
        event.page,
        event.size,
        );

    response.fold(
        (failure) => emit(ExtraServiceErrorState(message: failure.message)),
        (data) => emit(ExtraServiceSuccessState(extraServices: data)),
    );
  }
}
