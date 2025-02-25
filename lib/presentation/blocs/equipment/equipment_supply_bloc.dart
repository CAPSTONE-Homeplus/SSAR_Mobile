import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/constant.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_event.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_state.dart';

import '../../../domain/use_cases/equipment_supply/get_equipment_supplies_use_case.dart';

class EquipmentSupplyBloc
    extends Bloc<EquipmentSupplyEvent, EquipmentSupplyState> {
  final GetEquipmentSuppliesUseCase getEquipmentSuppliesUseCase;

  EquipmentSupplyBloc({required this.getEquipmentSuppliesUseCase})
      : super(EquipmentSupplyInitialState()) {
    on<GetEquipmentSupplies>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetEquipmentSupplies event,
    Emitter<EquipmentSupplyState> emit,
  ) async {
    emit(EquipmentSupplyLoadingState());
      final response = await getEquipmentSuppliesUseCase.execute(
        event.serviceId,
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

    response.fold(
            (failure) => emit(EquipmentSupplyErrorState(message: failure.message)),
            (data) => emit(EquipmentSupplySuccessState(equipmentSupplies: data)),
      );
  }
}
