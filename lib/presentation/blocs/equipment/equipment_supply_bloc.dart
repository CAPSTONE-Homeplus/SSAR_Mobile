import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_event.dart';
import 'package:home_clean/presentation/blocs/equipment/equipment_supply_state.dart';

import '../../../domain/use_cases/equipment_supply/get_equipment_supplies_usecase.dart';

class EquipmentSupplyBloc
    extends Bloc<EquipmentSupplyEvent, EquipmentSupplyState> {
  final GetEquipmentSuppliesUsecase getEquipmentSuppliesUsecase;

  EquipmentSupplyBloc({required this.getEquipmentSuppliesUsecase})
      : super(EquipmentSupplyInitialState()) {
    on<GetEquipmentSupplies>(_onGetServicesEvent);
  }

  Future<void> _onGetServicesEvent(
    GetEquipmentSupplies event,
    Emitter<EquipmentSupplyState> emit,
  ) async {
    emit(EquipmentSupplyLoadingState());
    try {
      final response = await getEquipmentSuppliesUsecase.execute(
        event.serviceId,
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
      );

      emit(EquipmentSupplySuccessState(equipmentSupplies: response.items));
    } catch (e) {
      emit(EquipmentSupplyErrorState(message: e.toString()));
    }
  }
}
