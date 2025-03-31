import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/laundry_repositories/additional_service_repository.dart';
import 'additional_service_event.dart';
import 'additional_service_state.dart';

class AdditionalServiceBloc extends Bloc<AdditionalServiceEvent, AdditionalServiceState> {
  final AdditionalServiceRepository repository;

  AdditionalServiceBloc({required this.repository}) : super(AdditionalServiceInitial()) {
    on<FetchAdditionalService>(_onFetchAdditionalService);
  }

  Future<void> _onFetchAdditionalService(
      FetchAdditionalService event,
      Emitter<AdditionalServiceState> emit,
      ) async {
    emit(AdditionalServiceLoading());
    try {
      final response = await repository.getAdditionService(
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );
      emit(AdditionalServiceLoaded(
        services: response,
        total: response.total,
        page: response.page,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(AdditionalServiceError(e.toString()));
    }
  }
}
