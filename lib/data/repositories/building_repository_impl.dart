import 'package:home_clean/data/mappers/building_mapper.dart';

import '../../core/constant/api_constant.dart';
import '../../core/base/base_model.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/request/request.dart';
import '../../domain/entities/building/building.dart';
import '../../domain/repositories/building_repository.dart';
import '../models/building/building_model.dart';

class BuildingRepositoryImpl implements BuildingRepository {
  @override
  Future<BaseResponse<Building>> getBuildings(String? search, String? orderBy, int? page, int? size) async{
    try {
      final response = await homeCleanRequest.get(
          ApiConstant.buildings,
          queryParameters: {
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<Building> buildings = data
            .map((item) => BuildingMapper.toEntity(
            BuildingModel.fromJson(item)))
            .toList();

        return BaseResponse<Building>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: buildings,
        );
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }

  @override
  Future<Building?> getBuildingById(String? buildingId) async {
    try {
      final response = await homeCleanRequest.get(
          '${ApiConstant.buildings}/$buildingId',
          queryParameters: {
            'id ': buildingId,
          });

      if (response.statusCode == 200 && response.data != null) {
        return BuildingMapper.toEntity(BuildingModel.fromJson(response.data));
      } else {
        throw ApiException(
          traceId: response.data['traceId'],
          code: response.data['code'],
          message: response.data['message'] ?? 'Lỗi từ máy chủ',
          description: response.data['description'],
          timestamp: response.data['timestamp'],
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}