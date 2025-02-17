import 'package:home_clean/core/api_constant.dart';
import 'package:home_clean/core/base_model.dart';
import 'package:home_clean/core/exception_handler.dart';
import 'package:home_clean/core/request.dart';
import 'package:home_clean/data/mappers/equipment_supply_mapper.dart';
import 'package:home_clean/data/models/equipment_supply/equipment_supply_model.dart';
import 'package:home_clean/data/repositories/equipment_supply/equipment_supply_repository.dart';
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart';

class EquipmentSupplyRepositoryImpl implements EquipmentSupplyRepository {
  @override
  Future<BaseResponse<EquipmentSupply>> getEquipmentSupplies(
    String serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) async {
    try {
      final response = await homeCleanRequest.get(
          '${ApiConstant.SERVICES}/$serviceId/equipment-supplies',
          queryParameters: {
            'id': serviceId,
            'search': search,
            'orderBy': orderBy,
            'page': page,
            'size': size,
          });

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> data = response.data['items'] ?? [];

        List<EquipmentSupply> supplyList = data
            .map((item) => EquipmentSupplyMapper.toEntity(
                EquipmentSupplyModel.fromJson(item)))
            .toList();

        return BaseResponse<EquipmentSupply>(
          size: response.data['size'] ?? 0,
          page: response.data['page'] ?? 0,
          total: response.data['total'] ?? 0,
          totalPages: response.data['totalPages'] ?? 0,
          items: supplyList,
        );
      } else {
        throw ApiException(
          errorCode: response.statusCode,
          errorMessage: response.statusMessage ?? 'Lỗi không xác định',
          errorStatus: response.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ExceptionHandler.handleException(e);
    }
  }
}
