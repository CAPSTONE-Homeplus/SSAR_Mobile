import 'package:home_clean/core/base_model.dart';

import '../entities/building/building.dart';

abstract class BuildingRepository {
  Future<BaseResponse<Building>> getBuildings(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
}