import 'package:home_clean/core/base/base_model.dart';

import '../../repositories/house_repository.dart';
import '../../entities/house/house.dart';

class GetHouseByBuildingUseCase {
  final HouseRepository _houseRepository;

  GetHouseByBuildingUseCase(this._houseRepository);

  Future<BaseResponse<House>> execute(String buildingId, String? search
      , String? orderBy, int? page, int? size) {
    return _houseRepository.getHouseByBuilding(buildingId, search,
        orderBy, page, size);
  }
}