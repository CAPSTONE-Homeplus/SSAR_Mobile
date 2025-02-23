import '../../core/base/base_model.dart';
import '../entities/house/house.dart';

abstract class  HouseRepository {
  Future<BaseResponse<House>> getHouseByBuilding(
    String? buildingId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}