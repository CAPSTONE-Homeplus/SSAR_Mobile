import 'package:home_clean/data/models/building/building_model.dart';

import '../../domain/entities/building/building.dart';

class BuildingMapper {
  static Building toEntity (BuildingModel buildingModel){
    return Building(
      id: buildingModel.id,
      name: buildingModel.name,
      longitude: buildingModel.longitude,
      latitude: buildingModel.latitude,
      code: buildingModel.code,
      createdAt: buildingModel.createdAt,
      updatedAt: buildingModel.updatedAt,
      hubId: buildingModel.hubId,
      clusterId: buildingModel.clusterId,
      status: buildingModel.status,
    );
  }

  static BuildingModel toModel (Building building){
    return BuildingModel(
      id: building.id,
      name: building.name,
      longitude: building.longitude,
      latitude: building.latitude,
      code: building.code,
      createdAt: building.createdAt,
      updatedAt: building.updatedAt,
      hubId: building.hubId,
      clusterId: building.clusterId,
      status: building.status,
    );
  }
}
