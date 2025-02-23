import 'package:home_clean/data/models/house/house_model.dart';

import '../../domain/entities/house/house.dart';

class HouseMapper {
  static House toEntity(HouseModel model) {
    return House(
      id: model.id,
      no: model.no,
      numberOfRoom: model.numberOfRoom,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      code: model.code,
      bedroomCount: model.bedroomCount,
      bathroomCount: model.bathroomCount,
      hasBalcony: model.hasBalcony,
      furnishingStatus: model.furnishingStatus,
      squareMeters: model.squareMeters,
      orientation: model.orientation,
      contactTerms: model.contactTerms,
      occupacy: model.occupacy,
      buildingId: model.buildingId,
      houseTypeId: model.houseTypeId,
    );
  }

  static HouseModel toModel(House entity) {
    return HouseModel(
      id: entity.id,
      no: entity.no,
      numberOfRoom: entity.numberOfRoom,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      code: entity.code,
      bedroomCount: entity.bedroomCount,
      bathroomCount: entity.bathroomCount,
      hasBalcony: entity.hasBalcony,
      furnishingStatus: entity.furnishingStatus,
      squareMeters: entity.squareMeters,
      orientation: entity.orientation,
      contactTerms: entity.contactTerms,
      occupacy: entity.occupacy,
      buildingId: entity.buildingId,
      houseTypeId: entity.houseTypeId,
    );
  }
}