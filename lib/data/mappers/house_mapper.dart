import 'package:home_clean/data/models/house/house_model.dart';

import '../../domain/entities/house/house.dart';

class HouseMapper {
  static House toEntity(HouseModel houseModel){
    return House(
      id: houseModel.id,
      no: houseModel.no,
      numberOfRoom: houseModel.numberOfRoom,
      status: houseModel.status,
      createdAt: houseModel.createdAt,
      updatedAt: houseModel.updatedAt,
      code: houseModel.code,
      bedroomCount: houseModel.bedroomCount,
      bathroomCount: houseModel.bathroomCount,
      hasBalcony: houseModel.hasBalcony,
      furnishingStatus: houseModel.furnishingStatus,
      squareMeters: houseModel.squareMeters,
      orientation: houseModel.orientation,
      contactTerms: houseModel.contactTerms,
      occupacy: houseModel.occupacy,
      buildingId: houseModel.buildingId,
      houseTypeId: houseModel.houseTypeId
    );
  }

  static HouseModel toModel(House house){
    return HouseModel(
      id: house.id,
      no: house.no,
      numberOfRoom: house.numberOfRoom,
      status: house.status,
      createdAt: house.createdAt,
      updatedAt: house.updatedAt,
      code: house.code,
      bedroomCount: house.bedroomCount,
      bathroomCount: house.bathroomCount,
      hasBalcony: house.hasBalcony,
      furnishingStatus: house.furnishingStatus,
      squareMeters: house.squareMeters,
      orientation: house.orientation,
      contactTerms: house.contactTerms,
      occupacy: house.occupacy,
      buildingId: house.buildingId,
      houseTypeId: house.houseTypeId
    );
  }
}

