import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';

abstract class EquipmentSupplyState {}

class EquipmentSupplyInitialState extends EquipmentSupplyState {}

class EquipmentSupplyLoadingState extends EquipmentSupplyState {}

class EquipmentSupplySuccessState extends EquipmentSupplyState {
  final BaseResponse<EquipmentSupply> equipmentSupplies;

  EquipmentSupplySuccessState({required this.equipmentSupplies});
}

class EquipmentSupplyErrorState extends EquipmentSupplyState {
  final String message;

  EquipmentSupplyErrorState({required this.message});
}
