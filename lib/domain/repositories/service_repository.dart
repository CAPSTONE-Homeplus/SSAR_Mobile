import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/service/service.dart';

abstract class ServiceRepository {
  Future<BaseResponse<Service>> getServices(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  );
  Future<Service> getServiceById(String id);
}
