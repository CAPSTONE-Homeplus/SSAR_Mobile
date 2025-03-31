
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:home_clean/core/exception/failure.dart';
import '../../../domain/use_cases/laundry_service_type/get_laundry_item_type_by_service.dart';
import '../../../domain/use_cases/laundry_service_type/get_laundry_service_types_use_case.dart';
import 'laundry_service_type_event.dart';
import 'laundry_service_type_state.dart';

class LaundryServiceTypeBloc extends Bloc<LaundryServiceTypeEvent, LaundryServiceTypeState> {
  final GetLaundryServiceTypesUseCase getLaundryServiceTypesUseCase;
  final GetLaundryItemTypeByServiceUseCase getLaundryItemTypeByService;

  LaundryServiceTypeBloc(this.getLaundryServiceTypesUseCase, this.getLaundryItemTypeByService) : super(LaundryServiceTypeInitial()) {
    on<GetLaundryServiceTypes>(_onGetLaundryServiceTypes);
    on<GetLaundryItemTypeByService>(_onGetLaundryItemTypeByService);
  }

  Future<void> _onGetLaundryServiceTypes(
      GetLaundryServiceTypes event, Emitter<LaundryServiceTypeState> emit) async {
    emit(LaundryServiceTypeLoading());

    final Either<Failure, dynamic> result = await getLaundryServiceTypesUseCase.execute();

    result.fold(
          (failure) => emit(LaundryServiceTypeError(failure.message)),
          (data) => emit(LaundryServiceTypeLoaded(data)),
    );
  }

  Future<void> _onGetLaundryItemTypeByService(
      GetLaundryItemTypeByService event, Emitter<LaundryServiceTypeState> emit) async {
    emit(LaundryServiceTypeLoading());

    final Either<Failure, dynamic> result = await getLaundryItemTypeByService.execute(event.serviceTypeId);

    result.fold(
          (failure) => emit(LaundryServiceTypeError(failure.message)),
          (data) => emit(LaundryServiceTypeLoaded(data)),
    );
  }
}
