import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';

abstract class EquipmentSupplyRepository {
  Future<BaseResponse<EquipmentSupply>> getEquipmentSupplies(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}
