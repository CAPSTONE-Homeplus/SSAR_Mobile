import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:home_clean/core/exception/failure.dart';
import '../../../core/base/base_model.dart';
import '../../../domain/entities/laundry_item_type/laundry_item_type.dart';
import '../../../domain/use_cases/laundry_service_type/get_laundry_item_type_by_service.dart';
import 'laundry_item_type_event.dart';
import 'laundry_item_type_state.dart';

class LaundryItemTypeBloc extends Bloc<LaundryItemTypeEvent, LaundryItemTypeState> {
  final GetLaundryItemTypeByServiceUseCase getLaundryItemTypeByService;

  LaundryItemTypeBloc(this.getLaundryItemTypeByService) : super(LaundryItemTypeInitial()) {
    on<GetLaundryItemTypeByService>(_onGetLaundryItemTypeByService);
  }

  Future<void> _onGetLaundryItemTypeByService(
      GetLaundryItemTypeByService event, Emitter<LaundryItemTypeState> emit) async {
    emit(LaundryItemTypeLoading());

    final Either<Failure, BaseResponse<LaundryItemType>> result =
    await getLaundryItemTypeByService.execute(event.serviceTypeId);

    result.fold(
          (failure) => emit(LaundryItemTypeError(failure.message)),
          (data) {
        emit(LaundryItemTypeLoaded(data));
            },
    );
  }
}
