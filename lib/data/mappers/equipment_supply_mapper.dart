import 'package:home_clean/data/models/equipment_supply/equipment_supply_model.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';

class EquipmentSupplyMapper {
  static EquipmentSupply toEntity(EquipmentSupplyModel model) {
    return EquipmentSupply(
      id: model.id,
      name: model.name,
      urlImage: model.urlImage,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      serviceId: model.serviceId,
      code: model.code,
    );
  }

  static EquipmentSupplyModel toModel(EquipmentSupply entity) {
    return EquipmentSupplyModel(
      id: entity.id,
      name: entity.name,
      urlImage: entity.urlImage,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      serviceId: entity.serviceId,
      code: entity.code,
    );
  }
}
