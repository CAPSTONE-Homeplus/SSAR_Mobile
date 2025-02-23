import 'package:home_clean/data/mappers/house_mapper.dart';

import '../../core/base/base_model.dart';
import '../../core/constant/api_constant.dart';
import '../../core/exception/exception_handler.dart';
import '../../core/request/request.dart';
import '../../domain/entities/house/house.dart';
import '../../domain/repositories/house_repository.dart';
import '../models/house/house_model.dart';

class HouseRepositoryImpl implements HouseRepository {
  @override
  Future<BaseResponse<House>> getHouseByBuilding(
      String? buildingId, String? search, String? orderBy, int? page, int? size) async {
    try {
      final response = await homeCleanRequest.get(
          '${ApiConstant.buildings}/$buildingId/house',
          queryParameters: {
            'id': buildingId,
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<House> houses = data
            .map((item) =>
            HouseMapper.toEntity(HouseModel.fromJson(item)))
            .toList();

        return BaseResponse<House>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: houses,
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
}