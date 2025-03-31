import 'package:home_clean/core/base/base_model.dart';

import '../entities/laundry_item_type/laundry_item_type.dart';
import '../entities/laundry_service_type/laundry_service_type.dart';

abstract class LaundryServiceTypeRepository {
  Future<BaseResponse<LaundryServiceType>> getServiceTypes();
  Future<BaseResponse<LaundryItemType>> getLaundryItemTypeByService(String serviceTypeId);
}