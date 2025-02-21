import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';

import '../../repositories/equipment_supply_repository.dart';

class GetEquipmentSuppliesUsecase {
  final EquipmentSupplyRepository _equipmentRepository;

  GetEquipmentSuppliesUsecase(this._equipmentRepository);

  Future<BaseResponse<EquipmentSupply>> execute(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    return await _equipmentRepository.getEquipmentSupplies(
      serviceId,
      search,
      orderBy,
      page,
      size,
    );
  }
}
